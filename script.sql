/*
Сидоренко Никита Олегович 

Вариант 2

Описание соревнования автогонок класса Формула-1. 
Включает в себя: календарь чемпионата, список автогонщиков, составы команд, результаты соревнований. 
Каждая запись в календаре чемпионата состоит из: названия гран-при, её номера среди других гран-при, даты проведения, страны проведения и места проведения. 
Каждый элемент списка автогонщиков состоит из: фамилии, имени, даты рождения, страны и количества побед гонщика.
Составы команд характеризуются: названием команды, названием производителя мотора, двумя основными автогонщиками с номерами их машин, одного запасного автогонщика без номера машины, страны происхождения команды. 
Результаты соревнований представляют собой информацию по каждому автогонщику и каждому гран-при о месте, занятом данным автогонщиком на данном гран-при, количестве заработанных им очков на данном гран-при, времени, затраченном им на данную гонку или причине его схода, количестве кругов лидирования данного гонщика в данном гран-при.
В одной и той же стране может проводиться несколько гран-при в один и тот же год. 
Составы команд не могут меняться в течение года.
*/


-- Гран-при
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    season_year INTEGER NOT NULL,
    round_number INTEGER NOT NULL,      
    name VARCHAR(64) NOT NULL,
    event_date DATE NOT NULL,
    country VARCHAR(64) NOT NULL,
    place VARCHAR(64) NOT NULL,
    UNIQUE (season_year, round_number)
);

-- Гонщики
CREATE TABLE racers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    surname VARCHAR(64) NOT NULL,
    birth_date DATE NOT NULL,
    country VARCHAR(64),
    count_wins INTEGER NOT NULL DEFAULT 0
);

-- Команды 
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    season_year INTEGER NOT NULL,
    name VARCHAR(64) NOT NULL,
    engine_dev_name VARCHAR(64) NOT NULL,
    country VARCHAR(64) NOT NULL,
    UNIQUE (season_year, name)
);

-- Состав команды
CREATE TABLE team_racers (
    id SERIAL PRIMARY KEY,
    team_id INTEGER NOT NULL REFERENCES teams(id),
    racer_id INTEGER NOT NULL REFERENCES racers(id),
    role VARCHAR(8) NOT NULL CHECK (role IN ('main','reserve')),
    car_number INTEGER,      
    
    CHECK (
        (role = 'main' AND car_number IS NOT NULL) OR
        (role = 'reserve' AND car_number IS NULL)
    ),
	
    UNIQUE (team_id, racer_id),
    UNIQUE (team_id, car_number)
);

-- Результаты
CREATE TABLE results (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL REFERENCES events(id),
    racer_id INTEGER NOT NULL REFERENCES racers(id),
    position INTEGER,                
    points INTEGER NOT NULL DEFAULT 0,
    finish_time INTERVAL,               
    leav_reason VARCHAR(128),           
    laps_lead INTEGER NOT NULL DEFAULT 0,
	
    UNIQUE (event_id, racer_id),
	
    CHECK (
        (finish_time IS NOT NULL AND dnf_reason IS NULL) OR
        (finish_time IS NULL AND dnf_reason IS NOT NULL)
    )
);