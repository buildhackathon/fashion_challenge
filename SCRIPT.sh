#!/bin/bash

echo "👗 Setting up Fashion Design Database..."

# Remove existing database if it exists
if [ -f "fashion.db" ]; then
    echo "Removing existing database..."
    rm fashion.db
fi

# Create database and run schema
echo "Creating database schema..."
sqlite3 fashion.db < DATABASE.sql

# Seed the database
echo "Seeding database with sample data..."
sqlite3 fashion.db << 'EOF'

-- =============================================================================
-- SEED DATA FOR FASHION DESIGN DATABASE
-- =============================================================================

-- Insert Users
INSERT INTO USERS (first_name, last_name, email, password, role, portfolio_url) VALUES
('Emma', 'Designer', 'emma.designer@fashion.com', 'hashed_password_123', 'designer', 'https://emmadesigns.portfolio.com'),
('Marco', 'Styles', 'marco.styles@fashion.com', 'hashed_password_456', 'designer', 'https://marcostyles.behance.net'),
('Sophia', 'Client', 'sophia.client@luxurybrands.com', 'hashed_password_789', 'client', NULL),
('Admin', 'User', 'admin@fashionhouse.com', 'admin_password_999', 'admin', NULL),
('Lucas', 'Trendy', 'lucas.trendy@fashion.com', 'hashed_password_321', 'designer', 'https://lucastrendy.dribbble.com'),
('Isabella', 'Boutique', 'isabella@isabellasboutique.com', 'hashed_password_654', 'client', NULL);

-- Insert Materials
INSERT INTO MATERIAL (name, type, composition, supplier, cost_per_yard, color_options, notes) VALUES
('Organic Cotton Twill', 'fabric', '100% Organic Cotton', 'EcoFabrics Co', 15.50, 'Natural, Black, Navy, White', 'Sustainable and breathable'),
('Silk Charmeuse', 'fabric', '100% Mulberry Silk', 'Luxury Silks Ltd', 45.00, 'Ivory, Blush, Emerald, Midnight', 'Luxurious drape and shine'),
('Wool Crepe', 'fabric', '100% Virgin Wool', 'Premium Woolens', 32.00, 'Charcoal, Camel, Burgundy', 'Perfect for tailoring'),
('French Lace', 'trim', 'Cotton/Nylon Blend', 'Parisian Lace House', 25.00, 'White, Ivory, Black', 'Delicate floral pattern'),
('Mother of Pearl Buttons', 'hardware', 'Natural Shell', 'Button Craft Inc', 3.50, 'Natural, White, Gray', 'Elegant finish for formal wear'),
('Invisible Zipper', 'hardware', 'Nylon', 'Zipper Solutions', 2.25, 'Black, White, Navy, Beige', 'Seamless closure'),
('Cashmere Blend', 'fabric', '70% Cashmere, 30% Silk', 'Luxury Fibers Co', 85.00, 'Cream, Gray, Rose', 'Ultra-soft and warm'),
('Metallic Thread', 'trim', 'Polyester with Metallic Core', 'Embellish Pro', 8.00, 'Gold, Silver, Copper', 'For decorative stitching');

-- Insert Projects
INSERT INTO PROJECTS (designer_id, client_id, name, description, project_type, season, budget, deadline, status) VALUES
(1, 3, 'Spring Capsule Collection', 'Minimalist 10-piece capsule wardrobe for working women', 'collection', 'spring', 15000.00, '2024-03-15', 'design'),
(2, NULL, 'Eco-Conscious Streetwear', 'Sustainable urban fashion line', 'clothing', 'year_round', 8000.00, '2024-06-01', 'concept'),
(1, 6, 'Wedding Guest Dress', 'Elegant midi dress for summer wedding', 'clothing', 'summer', 1200.00, '2024-04-20', 'approved'),
(5, 3, 'Executive Handbag Line', 'Professional leather handbags for businesswomen', 'accessories', 'year_round', 5000.00, '2024-05-30', 'review'),
(2, NULL, 'Autumn Outerwear', 'Cozy yet chic coats and jackets', 'clothing', 'fall', 12000.00, '2024-08-15', 'concept'),
(1, NULL, 'Sustainable Footwear', 'Eco-friendly shoe collection', 'footwear', 'year_round', 7500.00, '2024-07-01', 'design');

-- Insert Designs
INSERT INTO DESIGNS (project_id, name, description, category, target_gender, size_range, primary_material_id, secondary_material_id, color_palette, sketch_url, estimated_cost, status) VALUES
(1, 'Classic Blazer', 'Tailored blazer with modern silhouette', 'jacket', 'female', 'XS-XL', 3, 5, 'Charcoal, Navy, Camel', '/sketches/blazer_001.jpg', 185.00, 'technical'),
(1, 'Silk Blouse', 'Flowing blouse with subtle drape', 'top', 'female', 'XS-XL', 2, 4, 'Ivory, Blush, Emerald', '/sketches/blouse_002.jpg', 125.00, 'approved'),
(2, 'Organic Hoodie', 'Comfortable hoodie from sustainable materials', 'top', 'unisex', 'XS-XXL', 1, NULL, 'Natural, Black, Navy', '/sketches/hoodie_003.jpg', 65.00, 'sketch'),
(3, 'Summer Midi Dress', 'Elegant A-line dress perfect for special occasions', 'dress', 'female', 'XS-XL', 2, 4, 'Blush, Emerald', '/sketches/dress_004.jpg', 220.00, 'approved'),
(4, 'Executive Tote', 'Structured leather tote with gold hardware', 'bag', 'female', 'One Size', NULL, NULL, 'Black, Cognac, Navy', '/sketches/tote_005.jpg', 280.00, 'technical'),
(5, 'Cashmere Coat', 'Luxury overcoat in cashmere blend', 'coat', 'female', 'XS-XL', 7, 5, 'Cream, Gray, Rose', '/sketches/coat_006.jpg', 450.00, 'sketch');

-- Insert Design Revisions
INSERT INTO DESIGN_REVISIONS (design_id, version_number, revision_notes, sketch_url, revised_by) VALUES
(1, 2, 'Adjusted shoulder line for better fit', '/sketches/blazer_001_v2.jpg', 1),
(1, 3, 'Added functional pocket details', '/sketches/blazer_001_v3.jpg', 1),
(2, 2, 'Client requested longer sleeves', '/sketches/blouse_002_v2.jpg', 1),
(4, 2, 'Shortened hemline by 2 inches per client feedback', '/sketches/dress_004_v2.jpg', 1),
(5, 2, 'Added interior pockets and laptop compartment', '/sketches/tote_005_v2.jpg', 2);

-- Insert Feedback
INSERT INTO FEEDBACK (design_id, reviewer_id, feedback_text, rating, feedback_type, status) VALUES
(1, 3, 'Love the modern cut! Could we see it in a lighter color?', 4, 'client', 'addressed'),
(2, 6, 'Beautiful drape, perfect for the office', 5, 'client', 'pending'),
(4, 3, 'Exactly what I envisioned for the summer wedding!', 5, 'client', 'addressed'),
(1, 2, 'Great silhouette, consider adding contrast stitching', 4, 'peer', 'pending'),
(5, 3, 'Very professional look, laptop compartment is essential', 4, 'client', 'addressed'),
(6, 5, 'Luxurious design, pricing might be high for target market', 3, 'peer', 'pending');

-- Insert Collections
INSERT INTO COLLECTIONS (designer_id, name, description, season, year, theme, color_story) VALUES
(1, 'Urban Minimalist', 'Clean lines meet city sophistication', 'spring', 2024, 'Modern simplicity', 'Neutral palette with pops of jewel tones'),
(2, 'Eco Warriors', 'Fashion with a conscience', 'year_round', 2024, 'Sustainability', 'Earth tones and organic dyes'),
(5, 'Power Dressing 2.0', 'Contemporary professional wear', 'fall', 2024, 'Modern authority', 'Rich burgundy, navy, and gold accents'),
(1, 'Timeless Elegance', 'Classic pieces with modern updates', 'year_round', 2024, 'Refined sophistication', 'Monochromatic with texture play');

-- Insert Collection Designs
INSERT INTO COLLECTION_DESIGNS (collection_id, design_id, order_in_collection) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 5, 1),
(4, 1, 1),
(4, 2, 2),
(4, 4, 3);

EOF

echo "✅ Database setup complete!"
echo ""
echo "📊 Database Statistics:"
sqlite3 fashion.db << 'EOF'
SELECT 'Users: ' || COUNT(*) FROM USERS;
SELECT 'Projects: ' || COUNT(*) FROM PROJECTS;
SELECT 'Materials: ' || COUNT(*) FROM MATERIAL;
SELECT 'Designs: ' || COUNT(*) FROM DESIGNS;
SELECT 'Design Revisions: ' || COUNT(*) FROM DESIGN_REVISIONS;
SELECT 'Feedback: ' || COUNT(*) FROM FEEDBACK;
SELECT 'Collections: ' || COUNT(*) FROM COLLECTIONS;
SELECT 'Collection Designs: ' || COUNT(*) FROM COLLECTION_DESIGNS;
EOF

echo ""
echo "🎯 Sample Queries:"
echo "View all projects: sqlite3 fashion.db 'SELECT p.name, u.first_name as designer, p.status, p.deadline FROM PROJECTS p JOIN USERS u ON p.designer_id = u.id;'"
echo "View designs with materials: sqlite3 fashion.db 'SELECT d.name, m1.name as primary_material, m2.name as secondary_material FROM DESIGNS d LEFT JOIN MATERIAL m1 ON d.primary_material_id = m1.id LEFT JOIN MATERIAL m2 ON d.secondary_material_id = m2.id;'"
echo "View collections: sqlite3 fashion.db 'SELECT c.name, u.first_name as designer, c.season, c.year FROM COLLECTIONS c JOIN USERS u ON c.designer_id = u.id;'"
echo ""
echo "👗 Fashion design database is ready for your use!"