 
SELECT 
    users.Id,
    users.User_name,
    users.Email,
    users.Full_name,
    users.Display_name,
    users.Phone,
    users.Avatar,
    users.Birthday,
    users.Rid,
    users.Xid,
    users.Sid,
    users.Token,
    users.Session,
    users.signer,
    users.Active
    FROM users
    WHERE (lower(users.User_name)=lower('qkrghdqja71@gmail.com') 
    OR lower(users.email)=lower('qkrghdqja71@gmail.com') 
    OR users.phone='qkrghdqja71@gmail.com')
    AND users.deleted_at is NULL