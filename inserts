/* =========================
   D1 - inserts.sql
   Insert representative sample data
   ========================= */

-- PARKS (insert in this order so IDs are predictable)
INSERT INTO Park (park_id, park_name, state, zipcode)
VALUES (seq_park.NEXTVAL, 'Yellowstone National Park', 'WY', '82190');

INSERT INTO Park (park_id, park_name, state, zipcode)
VALUES (seq_park.NEXTVAL, 'Yosemite National Park', 'CA', '95389');

INSERT INTO Park (park_id, park_name, state, zipcode)
VALUES (seq_park.NEXTVAL, 'Zion National Park', 'UT', '84767');

INSERT INTO Park (park_id, park_name, state, zipcode)
VALUES (seq_park.NEXTVAL, 'Grand Canyon National Park', 'AZ', '86023');

INSERT INTO Park (park_id, park_name, state, zipcode)
VALUES (seq_park.NEXTVAL, 'Rocky Mountain National Park', 'CO', '80517');

-- FACILITIES (Campsites + Tours)
-- Yellowstone Camp A will become facility_id = 1 if this is a clean run
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

-- VISITORS (insert so visitor_id = 1 exists)
INSERT INTO Visitor (visitor_id, full_name, email, phone)
VALUES (seq_visitor.NEXTVAL, 'Test Visitor One', 'visitor1@test.com', '240-000-0001');

INSERT INTO Visitor (visitor_id, full_name, email, phone)
VALUES (seq_visitor.NEXTVAL, 'Test Visitor Two', 'visitor2@test.com', '240-000-0002');

INSERT INTO Visitor (visitor_id, full_name, email, phone)
VALUES (seq_visitor.NEXTVAL, 'Test Visitor Three', 'visitor3@test.com', '240-000-0003');

INSERT INTO Visitor (visitor_id, full_name, email, phone)
VALUES (seq_visitor.NEXTVAL, 'Test Visitor Four', 'visitor4@test.com', '240-000-0004');

INSERT INTO Visitor (visitor_id, full_name, email, phone)
VALUES (seq_visitor.NEXTVAL, 'Test Visitor Five', 'visitor5@test.com', '240-000-0005');

-- TOUR_DETAIL (sample upcoming tours)
INSERT INTO Tour_Detail (tour_detail_id, facility_id, tour_time, spots_available)
VALUES (seq_tour_detail.NEXTVAL, 4, TIMESTAMP '2025-09-21 09:00:00', 10);

INSERT INTO Tour_Detail (tour_detail_id, facility_id, tour_time, spots_available)
VALUES (seq_tour_detail.NEXTVAL, 5, TIMESTAMP '2025-09-22 18:00:00', 5);

-- TRANSACTION_T (create a conflict for Zion between 2025-09-22 and 2025-09-25)
-- facility_id for Zion Tent Loop is 3 in a clean run (based on inserts above)
INSERT INTO Transaction_T (
    transaction_id, visitor_id, facility_id, transaction_type, start_time, num_days, status, total_price
) VALUES (
    seq_transaction_t.NEXTVAL, 2, 3, 2, TIMESTAMP '2025-09-22 10:30:00', 3, 1, 105
);

COMMIT;
