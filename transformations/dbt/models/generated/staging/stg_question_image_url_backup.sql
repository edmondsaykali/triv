select
    question_id,
    old_image_url,
    migrated_at
from {{ source('int_20260622144856211900_9c8e639e', 'question_image_url_backup') }}
