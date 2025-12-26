/* =========================
   D4 - Full Build and Test 
   Includes: Drops, Creates, Inserts, Procedures (F5, F6), Tests
   ========================= */



-- ====== DROPS (tables) ======
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Message CASCADE CONSTRAINTS';       EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Tour_Detail CASCADE CONSTRAINTS';   EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Transaction_T CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Visitor CASCADE CONSTRAINTS';       EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Facility CASCADE CONSTRAINTS';      EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Park CASCADE CONSTRAINTS';          EXCEPTION WHEN OTHERS THEN NULL; END; /

-- ====== DROPS (sequences) ======
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_message';       EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_tour_detail';   EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_transaction_t'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_visitor';       EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_facility';      EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_park';          EXCEPTION WHEN OTHERS THEN NULL; END; /

-- ====== CREATES (tables) ======
CREATE TABLE Park (
    park_id    NUMBER PRIMARY KEY,
    park_name  VARCHAR2(100) NOT NULL,
    state      VARCHAR2(2),
    zipcode    VARCHAR2(10),
    CONSTRAINT uq_park_name UNIQUE (park_name)
);

CREATE TABLE Facility (
    facility_id    NUMBER PRIMARY KEY,
    park_id        NUMBER NOT NULL,
    facility_name  VARCHAR2(120) NOT NULL,
    facility_type  CHAR(1) NOT NULL,
    max_people     NUMBER NOT NULL,
    price_per_day  NUMBER(10,2),
    CONSTRAINT fk_facility_park FOREIGN KEY (park_id) REFERENCES Park(park_id),
    CONSTRAINT ck_facility_type CHECK (facility_type IN ('C','T')),
    CONSTRAINT ck_facility_max_people CHECK (max_people > 0)
);

CREATE TABLE Visitor (
    visitor_id   NUMBER PRIMARY KEY,
    full_name    VARCHAR2(120) NOT NULL,
    email        VARCHAR2(150) NOT NULL,
    phone        VARCHAR2(30),
    CONSTRAINT uq_visitor_email UNIQUE (email)
);

CREATE TABLE Transaction_T (
    transaction_id     NUMBER PRIMARY KEY,
    visitor_id         NUMBER NOT NULL,
    facility_id        NUMBER NOT NULL,
    transaction_type   NUMBER NOT NULL,
    start_time         TIMESTAMP NOT NULL,
    num_days           NUMBER NOT NULL,
    status             NUMBER NOT NULL,
    total_price        NUMBER(10,2),
    CONSTRAINT fk_trans_visitor  FOREIGN KEY (visitor_id)  REFERENCES Visitor(visitor_id),
    CONSTRAINT fk_trans_facility FOREIGN KEY (facility_id) REFERENCES Facility(facility_id),
    CONSTRAINT ck_trans_days CHECK (num_days > 0),
    CONSTRAINT ck_trans_status CHECK (status IN (1,3))
);

CREATE TABLE Tour_Detail (
    tour_detail_id   NUMBER PRIMARY KEY,
    facility_id      NUMBER NOT NULL,
    tour_time        TIMESTAMP NOT NULL,
    spots_available  NUMBER NOT NULL,
    CONSTRAINT fk_tour_facility FOREIGN KEY (facility_id) REFERENCES Facility(facility_id),
    CONSTRAINT ck_tour_spots CHECK (spots_available >= 0)
);

CREATE TABLE Message (
    message_id    NUMBER PRIMARY KEY,
    message_time  TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    visitor_id    NUMBER NOT NULL,
    message_body  VARCHAR2(4000) NOT NULL,
    CONSTRAINT fk_message_visitor FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id)
);

-- ====== CREATES (sequences) ======
CREATE SEQUENCE seq_park          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_facility      START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_visitor       START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_transaction_t START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tour_detail   START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_message       START WITH 1 INCREMENT BY 1;

-- ====== INSERTS ======
INSERT INTO Park (park_id, park_name, state, zipcode) VALUES (seq_park.NEXTVAL, 'Yellowstone National Park', 'WY', '82190');
INSERT INTO Park (park_id, park_name, state, zipcode) VALUES (seq_park.NEXTVAL, 'Yosemite National Park', 'CA', '95389');
INSERT INTO Park (park_id, park_name, state, zipcode) VALUES (seq_park.NEXTVAL, 'Zion National Park', 'UT', '84767');
INSERT INTO Park (park_id, park_name, state, zipcode) VALUES (seq_park.NEXTVAL, 'Grand Canyon National Park', 'AZ', '86023');
INSERT INTO Park (park_id, park_name, state, zipcode) VALUES (seq_park.NEXTVAL, 'Rocky Mountain National Park', 'CO', '80517');

INSERT INTO Facility (facility_id, park_id, facility_name, facility_type, max_people, price_per_day)
VALUES (seq_facility.NEXTVAL, 1, 'Yellowstone Camp A', 'C', 6, 40);
INSERT INTO Facility (facility_id, park_id, facility_name, facility_type, max_people, price_per_day)
VALUES (seq_facility.NEXTVAL, 2, 'Yosemite Family Camp', 'C', 8, 55);
INSERT INTO Facility (facility_id, park_id, facility_name, facility_type, max_people, price_per_day)
VALUES (seq_facility.NEXTVAL, 3, 'Zion Tent Loop', 'C', 4, 35);
INSERT INTO Facility (facility_id, park_id, facility_name, facility_type, max_people, price_per_day)
VALUES (seq_facility.NEXTVAL, 4, 'Grand Canyon Rim Tour', 'T', 25, 25);
INSERT INTO Facility (facility_id, park_id, facility_name, facility_type, max_people, price_per_day)
VALUES (seq_facility.NEXTVAL, 5, 'Rocky Mountain Sunset Tour', 'T', 20, 30);

INSERT INTO Visitor (visitor_id, full_name, email, phone) VALUES (seq_visitor.NEXTVAL, 'Test Visitor One', 'visitor1@test.com', '240-000-0001');
INSERT INTO Visitor (visitor_id, full_name, email, phone) VALUES (seq_visitor.NEXTVAL, 'Test Visitor Two', 'visitor2@test.com', '240-000-0002');

INSERT INTO Tour_Detail (tour_detail_id, facility_id, tour_time, spots_available)
VALUES (seq_tour_detail.NEXTVAL, 4, TIMESTAMP '2025-09-21 09:00:00', 10);

-- Create a conflict for Zion Tent Loop (facility_id = 3)
INSERT INTO Transaction_T (transaction_id, visitor_id, facility_id, transaction_type, start_time, num_days, status, total_price)
VALUES (seq_transaction_t.NEXTVAL, 2, 3, 2, TIMESTAMP '2025-09-22 10:30:00', 3, 1, 105);

COMMIT;

-- ====== PROCEDURES (YOUR FEATURES) ======

-- Feature 5
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

-- Feature 6
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

-- ====== TESTS (YOUR FEATURES) ======

-- Feature 5 tests
EXEC send_message_notification(1, 'Your reservation was confirmed.');
-- Expected: Message sent successfully.
SELECT message_id, message_time, visitor_id, message_body FROM Message WHERE visitor_id = 1 ORDER BY message_time DESC;

EXEC send_message_notification(999, 'Invalid visitor test.');
-- Expected: Invalid visitor ID.
SELECT * FROM Message WHERE visitor_id = 999;

-- Feature 6 tests
EXEC list_available_campsites('Yellowstone National Park', DATE '2025-09-10', DATE '2025-09-15', 4);
-- Expected: Campsite: Yellowstone Camp A | Max People: 6

EXEC list_available_campsites('Fake Park', DATE '2025-09-10', DATE '2025-09-15', 2);
-- Expected: No such park.

EXEC list_available_campsites('Zion National Park', DATE '2025-09-20', DATE '2025-09-25', 2);
-- Expected: No matches
