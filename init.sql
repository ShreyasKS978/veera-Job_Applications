-- Table: applications
CREATE TABLE applications (
    id SERIAL PRIMARY KEY,
    personal_info JSONB NOT NULL,
    education JSONB NOT NULL,
    work_experience JSONB NOT NULL,
    documents JSONB NOT NULL,
    date TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL
);

-- Table: application_files
CREATE TABLE application_files (
    id UUID PRIMARY KEY,
    application_id INTEGER REFERENCES applications(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    path VARCHAR(255) NOT NULL,
    size BIGINT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    hash TEXT,  -- ✅ Added column to store file hash
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: offer_letters
CREATE TABLE offer_letters (
    id UUID PRIMARY KEY,
    application_id INTEGER REFERENCES applications(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
