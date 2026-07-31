-- library_files 테이블에 삭제 정책 추가
-- 기존 정책 확인 및 삭제 정책 추가

-- 모든 사용자가 삭제할 수 있도록 허용 (anon key로 접근 가능)
CREATE POLICY "Anyone can delete library files"
    ON library_files FOR DELETE
    USING (true);

-- 또는 더 안전하게, 삽입도 허용
CREATE POLICY "Anyone can insert library files"
    ON library_files FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Anyone can update library files"
    ON library_files FOR UPDATE
    USING (true)
    WITH CHECK (true);
