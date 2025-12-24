/* =========================
   D2 - Feature 5
   Send Message Notification
   ========================= */

CREATE OR REPLACE PROCEDURE send_message_notification(
    p_visitor_id   IN NUMBER,
    p_message_body IN VARCHAR2
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM Visitor
    WHERE visitor_id = p_visitor_id;

    IF v_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid visitor ID.');
        RETURN;
    END IF;

    INSERT INTO Message (message_id, message_time, visitor_id, message_body)
    VALUES (seq_message.NEXTVAL, SYSTIMESTAMP, p_visitor_id, p_message_body);

    DBMS_OUTPUT.PUT_LINE('Message sent successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
-- Tests (one-line EXECs)
EXEC send_message_notification(1, 'Your reservation was confirmed.');
SELECT message_id, message_time, visitor_id, message_body FROM Message WHERE visitor_id = 1 ORDER BY message_time DESC;

EXEC send_message_notification(999, 'Invalid visitor test.');
SELECT * FROM Message WHERE visitor_id = 999;
