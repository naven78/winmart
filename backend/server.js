const express = require('express');
const fs = require('fs');
const xml2js = require('xml2js');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

// Function to read XML database
const readDatabase = () => {
    const xmlData = fs.readFileSync(path.join(__dirname, 'database.xml'), 'utf-8');
    return new Promise((resolve, reject) => {
        xml2js.parseString(xmlData, { explicitArray: false }, (err, result) => {
            if (err) reject(err);
            else resolve(result);
        });
    });
};

// Function to write to XML database
const writeDatabase = (data) => {
    const builder = new xml2js.Builder();
    const xml = builder.buildObject(data);
    fs.writeFileSync(path.join(__dirname, 'database.xml'), xml);
};

// Get all products
app.get('/api/products', async (req, res) => {
    try {
        const database = await readDatabase();
        // Check if the expected structure exists
        if (!database.database || !database.database.products || !database.database.products.product) {
            return res.status(500).json({ message: 'Invalid database structure' });
        }

        let products = database.database.products.product;
        
        // If category is specified in query params, filter by category
        if (req.query.category) {
            products = products.filter(product => product.category === req.query.category);
        }

        // Map products to the expected format
        const formattedProducts = products.map(product => ({
            name: product.name,
            price: product.price,
            category: product.category,
            image: product.image,
            discount: product.discount ? parseFloat(product.discount) : 0,
            userLiked: product.userLiked === 'true'
        }));

        res.json(formattedProducts);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ message: error.message });
    }
});

// Get product by name
app.get('/api/products/:name', async (req, res) => {
    try {
        const database = await readDatabase();
        const product = database.database.products.product.find(
            p => p.name.toLowerCase() === req.params.name.toLowerCase()
        );
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }
        res.json({
            name: product.name,
            price: product.price,
            description: product.description,
            stock: parseInt(product.stock),
            image: product.image,
            discount: parseFloat(product.discount),
            userLiked: product.userLiked === 'true'
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Update product like status
app.patch('/api/products/:name/like', async (req, res) => {
    try {
        const database = await readDatabase();
        const productIndex = database.database.products.product.findIndex(
            p => p.name.toLowerCase() === req.params.name.toLowerCase()
        );
        
        if (productIndex === -1) {
            return res.status(404).json({ message: 'Product not found' });
        }

        // Toggle userLiked status
        database.database.products.product[productIndex].userLiked = 
            database.database.products.product[productIndex].userLiked === 'true' ? 'false' : 'true';

        writeDatabase(database);
        res.json({ 
            userLiked: database.database.products.product[productIndex].userLiked === 'true'
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
