CREATE TABLE IF NOT EXISTS engine_components (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(10) NOT NULL,
    pistons VARCHAR(50),
    pistons_durability FLOAT,
    conrods VARCHAR(50),
    conrods_durability FLOAT,
    head VARCHAR(50),
    head_durability FLOAT,
    valves VARCHAR(50),
    valves_durability FLOAT,
    radiator VARCHAR(50),
    radiator_durability FLOAT,
    turbo VARCHAR(50),
    turbo_durability FLOAT,
    target_boost FLOAT,
    UNIQUE KEY (plate)
);

CREATE TABLE IF NOT EXISTS engine_damage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(10) NOT NULL,
    damage FLOAT,
    UNIQUE KEY (plate)
);