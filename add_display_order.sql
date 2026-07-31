-- archive_videos 테이블에 display_order 컬럼 추가
ALTER TABLE archive_videos ADD COLUMN IF NOT EXISTS display_order INTEGER DEFAULT 0;

-- 기존 데이터에 순서 부여 (id 순서대로)
UPDATE archive_videos SET display_order = id WHERE display_order = 0;

-- 순서 업데이트 RPC 함수
CREATE OR REPLACE FUNCTION admin_update_video_order(
    p_video_id INTEGER,
    p_new_order INTEGER
) RETURNS VOID AS $$
BEGIN
    UPDATE archive_videos
    SET display_order = p_new_order
    WHERE id = p_video_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
