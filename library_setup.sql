-- 자료실 파일 테이블 생성
CREATE TABLE IF NOT EXISTS library_files (
    id SERIAL PRIMARY KEY,
    file_name TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_size BIGINT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 관리자 RPC 함수: 파일 생성
CREATE OR REPLACE FUNCTION admin_create_library_file(
    p_token TEXT,
    p_file_name TEXT,
    p_file_url TEXT,
    p_file_size BIGINT
) RETURNS VOID AS $$
BEGIN
    IF NOT is_admin_authenticated(p_token) THEN
        RAISE EXCEPTION 'Unauthorized';
    END IF;

    INSERT INTO library_files (file_name, file_url, file_size)
    VALUES (p_file_name, p_file_url, p_file_size);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 관리자 RPC 함수: 파일 삭제
CREATE OR REPLACE FUNCTION admin_delete_library_file(
    p_token TEXT,
    p_id INT
) RETURNS VOID AS $$
BEGIN
    IF NOT is_admin_authenticated(p_token) THEN
        RAISE EXCEPTION 'Unauthorized';
    END IF;

    DELETE FROM library_files WHERE id = p_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS 정책 설정
ALTER TABLE library_files ENABLE ROW LEVEL SECURITY;

-- 모든 사용자가 파일 목록을 읽을 수 있도록 허용
CREATE POLICY "Anyone can read library files"
    ON library_files FOR SELECT
    USING (true);
