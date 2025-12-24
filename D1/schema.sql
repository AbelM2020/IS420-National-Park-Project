/* =========================
   D1 - schema.sql
   National Park Service Portal (Oracle)
   ========================= */

-- PARK
CREATE TABLE Park (
    park_id    NUMBER PRIMARY KEY,
    park_name  VARCHAR2(100) NOT NULL,
    state      VARCHAR2(2),
    zipcode    VARCHAR2(10),
    CONSTRAINT uq_park_name UNIQUE (park_name)
);

-- FACILITY (C = campsite, T = tour)
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

-- VISITOR
CREATE TABLE Visitor (
    visitor_id   NUMBER PRIMARY KEY,
    full_name    VARCHAR2(120) NOT NULL,
    email        VARCHAR2(150) NOT NULL,
    phone        VARCHAR2(30),
    CONSTRAINT uq_visitor_email UNIQUE (email)
);

-- TRANSACTION_T (reservations)
-- status: 1 = active, 3 = canceled
-- transaction_type: 2 = campsite reservation (matches Feature 6 logic)
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

-- TOUR_DETAIL (optional table used by other features)
CREATE TABLE Tour_Detail (
    tour_detail_id   NUMBER PRIMARY KEY,
    facility_id      NUMBER NOT NULL,
    tour_time        TIMESTAMP NOT NULL,
    spots_available  NUMBER NOT NULL,
    CONSTRAINT fk_tour_facility FOREIGN KEY (facility_id) REFERENCES Facility(facility_id),
    CONSTRAINT ck_tour_spots CHECK (spots_available >= 0)
);

-- MESSAGE
CREATE TABLE Message (
    message_id    NUMBER PRIMARY KEY,
    message_time  TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    visitor_id    NUMBER NOT NULL,
    message_body  VARCHAR2(4000) NOT NULL,
    CONSTRAINT fk_message_visitor FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id)
);

-- SEQUENCES
CREATE SEQUENCE seq_park          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_facility      START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_visitor       START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_transaction_t START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tour_detail   START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_message       START WITH 1 INCREMENT BY 1;
