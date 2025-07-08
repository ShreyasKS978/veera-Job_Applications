-- Create the database tables for job applications system

CREATE TABLE IF NOT EXISTS applications (
    id SERIAL PRIMARY KEY,
    personal_info JSONB NOT NULL,
    education JSONB NOT NULL,
    work_experience JSONB NOT NULL,
    documents JSONB NOT NULL,
    date TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS application_files (
    id UUID PRIMARY KEY,
    application_id INTEGER REFERENCES applications(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    path VARCHAR(255) NOT NULL,
    size INTEGER NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    hash VARCHAR(64) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_applications_status ON applications(status);
CREATE INDEX IF NOT EXISTS idx_applications_date ON applications(date);
CREATE INDEX IF NOT EXISTS idx_application_files_app_id ON application_files(application_id);

-- Create function for text search (optional but useful)
CREATE OR REPLACE FUNCTION applications_search_text(app applications)
RETURNS TEXT AS $$
BEGIN
    RETURN (
        app.personal_info->>'name' || ' ' ||
        app.personal_info->>'email' || ' ' ||
        app.personal_info->>'phone'
    );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Create a view for easier querying (optional)
CREATE OR REPLACE VIEW applications_view AS
SELECT 
    id,
    personal_info->>'name' AS name,
    personal_info->>'email' AS email,
    personal_info->>'phone' AS phone,
    status,
    date,
    (SELECT COUNT(*) FROM application_files WHERE application_id = applications.id) AS file_count
FROM applications;

-- Add comments to tables and columns (documentation)
COMMENT ON TABLE applications IS 'Stores job application submissions';
COMMENT ON COLUMN applications.personal_info IS 'JSON containing personal information (name, email, phone, etc.)';
COMMENT ON COLUMN applications.education IS 'JSON containing education details';
COMMENT ON COLUMN applications.work_experience IS 'JSON containing work experience details';
COMMENT ON COLUMN applications.documents IS 'JSON containing document references';

COMMENT ON TABLE application_files IS 'Stores files uploaded for applications (offer letters, etc.)';
COMMENT ON COLUMN application_files.hash IS 'SHA-256 hash of file contents for integrity verification';
