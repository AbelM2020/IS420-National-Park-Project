/* =========================
   D3 - Feature 6
   List Available Campsites
   ========================= */

CREATE OR REPLACE PROCEDURE list_available_campsites(
    p_park_name    IN VARCHAR2,
    p_start_date   IN DATE,
    p_end_date     IN DATE,
    p_num_people   IN NUMBER
) AS
    v_park_id NUMBER;
    v_count   NUMBER;
    v_found   BOOLEAN := FALSE;
BEGIN
    BEGIN
        SELECT park_id INTO v_park_id
        FROM Park
        WHERE LOWER(park_name) = LOWER(p_park_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No such park.');
            RETURN;
    END;

    FOR site IN (
        SELECT facility_id, facility_name, max_people
        FROM Facility
        WHERE park_id = v_park_id
          AND facility_type = 'C'
          AND max_people >= p_num_people
    )
    LOOP
        SELECT COUNT(*) INTO v_count
        FROM Transaction_T
        WHERE facility_id = site.facility_id
          AND transaction_type = 2
          AND status != 3
          AND TRUNC(start_time) < p_end_date
          AND p_start_date < TRUNC(start_time) + num_days;

        IF v_count = 0 THEN
            v_found := TRUE;
            DBMS_OUTPUT.PUT_LINE('Campsite: ' || site.facility_name || ' | Max People: ' || site.max_people);
        END IF;
    END LOOP;

    IF v_found = FALSE THEN
        DBMS_OUTPUT.PUT_LINE('No matches');
    END IF;
END;
/
-- Tests (one-line EXECs)
EXEC list_available_campsites('Yellowstone National Park', DATE '2025-09-10', DATE '2025-09-15', 4);
EXEC list_available_campsites('Fake Park', DATE '2025-09-10', DATE '2025-09-15', 2);
EXEC list_available_campsites('Zion National Park', DATE '2025-09-20', DATE '2025-09-25', 2);
