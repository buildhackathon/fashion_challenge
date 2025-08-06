-- Users table
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
-- Projects table
CREATE TABLE IF NOT EXISTS PROJECTS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    designer_id INTEGER NOT NULL,
    client_id INTEGER,
    name TEXT NOT NULL,
    description TEXT,
    project_type TEXT CHECK(
        project_type IN (
            'clothing',
            'accessories',
            'footwear',
            'collection'
        )
    ) NOT NULL,
    season TEXT CHECK(
        season IN (
            'spring',
            'summer',
            'fall',
            'winter',
            'year_round'
        )
    ) NOT NULL,
    budget DECIMAL(10, 2),
    deadline DATE,
    status TEXT CHECK(
        status IN (
            'concept',
            'design',
            'review',
            'approved',
            'production',
            'completed',
            'cancelled'
        )
    ) DEFAULT 'concept',
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (designer_id) REFERENCES USERS(id),
    FOREIGN KEY (client_id) REFERENCES USERS(id)
);
-- Material table
CREATE TABLE IF NOT EXISTS MATERIAL (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT CHECK(type IN ('fabric', 'trim', 'hardware')) NOT NULL,
    composition TEXT,
    supplier TEXT,
    cost_per_yard DECIMAL(8, 2),
    color_options TEXT,
    notes TEXT,
);
-- Designs table
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
    estimated_cost DECIMAL(8, 2),
    status TEXT CHECK(
        status IN (
            'sketch',
            'technical',
            'approved',
            'rejected',
            'in_production'
        )
    ) DEFAULT 'sketch',
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES PROJECTS(id) ON DELETE CASCADE,
    FOREIGN KEY (primary_material_id) REFERENCES MATERIAL(id),
    FOREIGN KEY (secondary_material_id) REFERENCES MATERIAL(id)
);
-- Design revisions table
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
-- Feedback table
CREATE TABLE IF NOT EXISTS FEEDBACK (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    design_id INTEGER NOT NULL,
    reviewer_id INTEGER NOT NULL,
    feedback_text TEXT NOT NULL,
    rating INTEGER CHECK(
        rating BETWEEN 1 AND 5
    ),
    feedback_type TEXT CHECK(feedback_type IN ('client', 'peer', 'internal')) NOT NULL,
    status TEXT CHECK(status IN ('pending', 'addressed', 'dismissed')) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (design_id) REFERENCES DESIGNS(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES USERS(id)
);
-- Collections table
CREATE TABLE IF NOT EXISTS COLLECTIONS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    designer_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    season TEXT CHECK(
        season IN (
            'spring',
            'summer',
            'fall',
            'winter',
            'year_round'
        )
    ) NOT NULL,
    year INTEGER NOT NULL,
    theme TEXT,
    color_story TEXT,
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (designer_id) REFERENCES USERS(id)
);
-- Collection designs table (many-to-many)
CREATE TABLE IF NOT EXISTS COLLECTION_DESIGNS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    collection_id INTEGER NOT NULL,
    design_id INTEGER NOT NULL,
    order_in_collection INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (collection_id) REFERENCES COLLECTIONS(id) ON DELETE CASCADE,
    FOREIGN KEY (design_id) REFERENCES DESIGNS(id) ON DELETE CASCADE
);
-- Performance Indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON USERS(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON USERS(role);
CREATE INDEX IF NOT EXISTS idx_projects_designer ON PROJECTS(designer_id);
CREATE INDEX IF NOT EXISTS idx_projects_client ON PROJECTS(client_id);
CREATE INDEX IF NOT EXISTS idx_projects_status ON PROJECTS(status);
CREATE INDEX IF NOT EXISTS idx_materials_type ON MATERIALS(type);
CREATE INDEX IF NOT EXISTS idx_designs_project ON DESIGNS(project_id);
CREATE INDEX IF NOT EXISTS idx_designs_category ON DESIGNS(category);
CREATE INDEX IF NOT EXISTS idx_designs_status ON DESIGNS(status);
CREATE INDEX IF NOT EXISTS idx_designs_primary_material ON DESIGNS(primary_material_id);
CREATE INDEX IF NOT EXISTS idx_revisions_design ON DESIGN_REVISIONS(design_id);
CREATE INDEX IF NOT EXISTS idx_feedback_design ON FEEDBACK(design_id);
CREATE INDEX IF NOT EXISTS idx_collections_designer ON COLLECTIONS(designer_id);