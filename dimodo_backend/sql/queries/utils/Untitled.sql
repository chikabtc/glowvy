DELETE FROM product a USING (
      SELECT MIN(ctid) as ctid, sid
        FROM product 
        GROUP BY sid HAVING COUNT(*) > 1
      ) b
      WHERE a.sid = b.sid 
      AND a.ctid <> b.ctid