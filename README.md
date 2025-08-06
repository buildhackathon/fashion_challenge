## Global Fields

```SQL
    is_active BOOLEAN DEFAULT 1
```

Enables soft deletion to maintain design history and project integrity.

```SQL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

Standard audit fields for tracking design iterations and project timelines.

## 1) Users Table

```SQL
CREATE TABLE IF NOT EXISTS USERS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role TEXT CHECK(role IN ('designer', 'client', 'admin')) NOT NULL DEFAULT 'designer',
    portfolio_url TEXT,
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

- **Three user roles**: Designers, clients, and admins
- **Portfolio integration**: Link to designer portfolios and work samples
- **Simple profile**: Essential contact and role information
- **Designer-focused**: Primary users are fashion designers and their clients

## 2) Projects Table

```SQL
CREATE TABLE IF NOT EXISTS PROJECTS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    designer_id INTEGER NOT NULL,
    client_id INTEGER,
    name TEXT NOT NULL,
    description TEXT,
    project_type TEXT CHECK(project_type IN ('clothing', 'accessories', 'footwear', 'collection')) NOT NULL,
    season TEXT CHECK(season IN ('spring', 'summer', 'fall', 'winter', 'year_round')) NOT NULL,
    budget DECIMAL(10,2),
    deadline DATE,
    status TEXT CHECK(status IN ('concept', 'design', 'review', 'approved', 'production', 'completed', 'cancelled')) DEFAULT 'concept',
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (designer_id) REFERENCES USERS(id),
    FOREIGN KEY (client_id) REFERENCES USERS(id)
);
```

- **Project management**: Complete project lifecycle from concept to completion
- **Fashion seasons**: Standard fashion calendar seasons plus year-round
- **Project types**: Clothing, accessories, footwear, or full collections
- **Client collaboration**: Optional client assignment for commissioned work
- **Budget and timeline**: Financial constraints and deadline tracking

## 3) Materials Table

```SQL
CREATE TABLE IF NOT EXISTS MATERIALS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT CHECK(type IN ('fabric', 'trim', 'hardware')) NOT NULL,
    composition TEXT,
    supplier TEXT,
    cost_per_yard DECIMAL(8,2),
    color_options TEXT,
    notes TEXT,
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

- **Material library**: Centralized database of fabrics, trims, and hardware
- **Material types**: Fabric (main materials), trim (details), hardware (buttons, zippers)
- **Composition tracking**: Fiber content and material makeup
- **Supplier management**: Track where materials can be sourced
- **Cost planning**: Per-yard pricing for budget calculations
- **Color options**: Available colorways for each material
- **Reusable library**: Materials can be used across multiple designs

## 4) Designs Table

```SQL
CREATE TABLE IF NOT EXISTS DESIGNS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL,
    target_gender TEXT CHECK(target_gender IN ('male', 'female', 'unisex')) NOT NULL,
    size_range TEXT NOT NULL,
    primary_material_id INTEGER,
    secondary_material_id INTEGER,
    color_palette TEXT,
    sketch_url TEXT,
    tech_pack_url TEXT,
    estimated_cost DECIMAL(8,2),
    status TEXT CHECK(status IN ('sketch', 'technical', 'approved', 'rejected', 'in_production')) DEFAULT 'sketch',
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES PROJECTS(id) ON DELETE CASCADE,
    FOREIGN KEY (primary_material_id) REFERENCES MATERIALS(id),
    FOREIGN KEY (secondary_material_id) REFERENCES MATERIALS(id)
);
```

- **Design details**: Complete garment specifications and descriptions
- **Category classification**: Dress, top, pants, jacket, shoes, bags, etc.
- **Target market**: Gender and size range specifications
- **Material integration**: Direct links to primary and secondary materials from materials library
- **Design assets**: Sketch and technical pack file storage
- **Color planning**: Color palette and story
- **Cost estimation**: Production cost calculations based on materials
- **Design workflow**: Sketch → Technical → Approved → Production

**Key Material Integration:**

- **Primary Material**: Main fabric or material (e.g., cotton twill for pants)
- **Secondary Material**: Accent or secondary fabric (e.g., satin lining)
- **Automatic cost calculation**: Can calculate estimated costs based on material pricing
- **Material reuse**: Same materials can be used across multiple designs

## 5) Design Revisions Table

```SQL
CREATE TABLE IF NOT EXISTS DESIGN_REVISIONS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    design_id INTEGER NOT NULL,
    version_number INTEGER NOT NULL,
    revision_notes TEXT,
    sketch_url TEXT,
    tech_pack_url TEXT,
    revised_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (design_id) REFERENCES DESIGNS(id) ON DELETE CASCADE,
    FOREIGN KEY (revised_by) REFERENCES USERS(id)
);
```

- **Version control**: Track all design iterations and changes
- **Revision documentation**: Notes explaining changes made
- **Asset versioning**: Updated sketches and technical packs
- **Change attribution**: Track who made specific revisions
- **Design history**: Complete audit trail of design evolution

## 6) Feedback Table

```SQL
CREATE TABLE IF NOT EXISTS FEEDBACK (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    design_id INTEGER NOT NULL,
    reviewer_id INTEGER NOT NULL,
    feedback_text TEXT NOT NULL,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    feedback_type TEXT CHECK(feedback_type IN ('client', 'peer', 'internal')) NOT NULL,
    status TEXT CHECK(status IN ('pending', 'addressed', 'dismissed')) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (design_id) REFERENCES DESIGNS(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES USERS(id)
);
```

- **Collaborative feedback**: Client and peer review system
- **Feedback categorization**: Client, peer review, or internal feedback
- **Rating system**: 1-5 star ratings for design evaluation
- **Status tracking**: Pending, addressed, or dismissed feedback
- **Review management**: Organize and respond to design critiques

## 7) Collections Table

```SQL
CREATE TABLE IF NOT EXISTS COLLECTIONS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    designer_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    season TEXT CHECK(season IN ('spring', 'summer', 'fall', 'winter', 'year_round')) NOT NULL,
    year INTEGER NOT NULL,
    theme TEXT,
    color_story TEXT,
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (designer_id) REFERENCES USERS(id)
);
```

- **Collection management**: Group related designs into cohesive collections
- **Seasonal organization**: Fashion calendar alignment
- **Creative direction**: Theme and color story documentation
- **Year tracking**: Multi-year collection history
- **Simplified structure**: Focus on essential collection information

## 8) Collection Designs Table

```SQL
CREATE TABLE IF NOT EXISTS COLLECTION_DESIGNS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    collection_id INTEGER NOT NULL,
    design_id INTEGER NOT NULL,
    order_in_collection INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (collection_id) REFERENCES COLLECTIONS(id) ON DELETE CASCADE,
    FOREIGN KEY (design_id) REFERENCES DESIGNS(id) ON DELETE CASCADE
);
```

- **Many-to-many relationship**: Designs can belong to multiple collections
- **Collection curation**: Organize designs within collections
- **Order management**: Sequence designs for presentations
- **Flexible grouping**: Same design can appear in different collections

## Materials Usage Examples

```SQL
-- Create materials
INSERT INTO MATERIALS (name, type, composition, supplier, cost_per_yard) VALUES
('Cotton Twill', 'fabric', '100% Cotton', 'Fabric Co', 12.50),
('Satin Lining', 'fabric', '100% Polyester', 'Lining Supply', 8.00),
('Metal Buttons', 'hardware', 'Brass', 'Button Works', 2.00);

-- Create design using materials
INSERT INTO DESIGNS (project_id, name, category, target_gender, size_range, 
                    primary_material_id, secondary_material_id) VALUES
(1, 'Classic Blazer', 'jacket', 'female', 'XS-XL', 1, 2);

-- Query designs with their materials
SELECT d.name as design_name, 
       m1.name as primary_material, 
       m2.name as secondary_material,
       (m1.cost_per_yard + m2.cost_per_yard) as material_cost_estimate
FROM DESIGNS d
LEFT JOIN MATERIALS m1 ON d.primary_material_id = m1.id
LEFT JOIN MATERIALS m2 ON d.secondary_material_id = m2.id;
```

## Performance Indexes

Optimized for design workflow with materials:

- **`idx_materials_type`**: Filter materials by type (fabric, trim, hardware)
- **`idx_designs_primary_material`**: Find designs using specific materials
- **`idx_projects_designer`**: Designer's project management
- **`idx_designs_project`**: Project design loading
- **`idx_designs_category`**: Category-based design filtering
- **`idx_feedback_design`**: Design review management

## How to set up (USING SQLITE3)

```bash
chmod +x SCRIPT.sh
./SCRIPT.sh
```