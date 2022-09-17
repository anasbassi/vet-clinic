/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT * FROM animals WHERE date_of_birth >= '2016-01-01' AND date_of_birth <= '2019-12-31';
SELECT * FROM animals WHERE neutered = 'true' AND escape_attempts < 3;
SELECT * FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals where weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = 'true';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;
BEGIN;
UPDATE animals SET species = 'unspecified';
UPDATE animals SET Species = 'digimon' WHERE Name like '%mon';
UPDATE animals SET Species = 'pokemon' WHERE Species = null;
COMMIT;
BEGIN;
DELETE FROM animals;
ROLLBACK;
BEGIN;
SAVEPOINT save_point;
DELETE FROM animals WHERE Date_of_birth > '2022-01-01';
SAVEPOINT save_point1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO save_point1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT COUNT(*) AS Total_number_of_animals FROM animals;
SELECT COUNT( escape_attempts ) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT name FROM animals WHERE escape_attempts = (SELECT MAX(escape_attempts) FROM animals);
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT ROUND(AVG(escape_attempts)::numeric, 0) FROM animals WHERE date_of_birth >= '1990-01-01' AND date_of_birth <= '2000-12-31';

SELECT animals.name FROM animals INNER JOIN owners ON animals.owners_id = owners.id WHERE owners.full_name = 'Melody Pond';
SELECT animals.name FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';
SELECT owners.full_name, animals.name FROM animals RIGHT JOIN owners ON animals.owners_id = owners.id ;
SELECT species.name, COUNT(*) FROM animals JOIN species ON animals.species_id = species.id GROUP by species.name;
SELECT animals.name FROM animals JOIN owners ON animals.owners_id = owners.id JOIN species ON animals.species_id = species.id WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';
SELECT animals.name FROM animals JOIN owners ON animals.owners_id = owners.id WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0 GROUP BY animals.name;
SELECT owners.full_name, COUNT(*) FROM owners JOIN animals ON owners.id = animals.owners_id GROUP BY owners.full_name ORDER BY COUNT(*) DESC LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT animals.name FROM animals
JOIN visits ON visits.animals_id = animals.id
WHERE vets_id = 1
ORDER BY date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT animals.name FROM animals
JOIN visits ON visits.animals_id = animals.id
WHERE vets_id = 3;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets
LEFT JOIN specializations ON specializations.vets_id = vets.id
LEFT JOIN species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, visits.date_of_visit FROM animals
JOIN visits ON visits.animals_id = animals.id
WHERE vets_id = 3 AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT COUNT(visits.animals_id) as visit_count, animals.name from animals
JOIN visits On animals.id = visits.animals_id
GROUP BY visits.animals_id, animals.name
ORDER BY visit_count DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name, vets.name, visits.date_of_visit FROM animals
JOIN visits ON animals.id = visits.animals_id
JOIN vets ON visits.vets_id = vets.id
WHERE visits.vets_id = 2
ORDER BY date_of_visit ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, vets.name, visits.date_of_visit FROM animals
JOIN visits ON animals.id = visits.animals_id
JOIN vets ON visits.vets_id = vets.id
WHERE visits.date_of_visit = '2021-05-04';

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM animals
INNER JOIN visits ON animals.id = visits.animals_id
INNER JOIN vets ON vets.id = visits.vets_id WHERE vets.id = 2;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT COUNT(visits.animals_id) AS count_visits, species.name FROM visits
JOIN animals ON animals.id = visits.animals_id
JOIN species ON animals.species_id = species.id
WHERE visits.vets_id = 2
GROUP BY species.name
ORDER BY count_visits DESC
LIMIT 1;