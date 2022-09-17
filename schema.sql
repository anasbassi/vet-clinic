/* Database schema to keep the structure of entire database. */
CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(250),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOL,
  weight_kg FLOAT,
  PRIMARY KEY(id)
);

ALTER TABLE animals ADD species VARCHAR(250);

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(250) NOT NULL,
    age INT,
    PRIMARY KEY(id)
);

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    PRIMARY KEY(id)
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);
ALTER TABLE animals ADD COLUMN owners_id INT REFERENCES owners(id);

CREATE TABLE vets (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100),
  age INT,
  date_of_graduation DATE,  
  PRIMARY KEY(id)
);

CREATE TABLE specializations (
  species_id INT,
  vets_id INT,
  FOREIGN kEY (species_id) REFERENCES species(id),
  FOREIGN kEY (vets_id) REFERENCES vets(id),
  PRIMARY kEY (species_id, vets_id)
);

CREATE TABLE visits (
  id INT GENERATED ALWAYS AS IDENTITY,
  animals_id INT,
  vets_id INT,
  date_of_visit DATE,
  FOREIGN KEY (animals_id) REFERENCES animals(id),
  FOREIGN KEY (vets_id) REFERENCES vets(id),
  PRIMARY KEY (id)
);
