-- Création de la base de données
CREATE DATABASE IF NOT EXISTS bibliotheque_db;
USE bibliotheque_db;

-- Table des livres
CREATE TABLE livres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255) NOT NULL,
    categorie VARCHAR(100),
    nombre_exemplaires INT DEFAULT 1,
    exemplaires_disponibles INT DEFAULT 1
);

-- Table des membres
CREATE TABLE membres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    adhesion_date DATE DEFAULT (CURRENT_DATE),
    statut VARCHAR(20) DEFAULT 'ACTIF'
);

-- Table des emprunts
CREATE TABLE emprunts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    membre_id INT NOT NULL,
    livre_id INT NOT NULL,
    date_emprunt DATE DEFAULT (CURRENT_DATE),
    date_retour_prevue DATE NOT NULL,
    date_retour_effective DATE,
    statut VARCHAR(20) DEFAULT 'EN_COURS',
    penalite DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (livre_id) REFERENCES livres(id) ON DELETE CASCADE
);

-- Index pour optimiser les recherches
CREATE INDEX idx_livres_titre ON livres(titre);
CREATE INDEX idx_livres_auteur ON livres(auteur);
CREATE INDEX idx_livres_categorie ON livres(categorie);
CREATE INDEX idx_membres_nom ON membres(nom);
CREATE INDEX idx_emprunts_membre ON emprunts(membre_id);
CREATE INDEX idx_emprunts_livre ON emprunts(livre_id);
CREATE INDEX idx_emprunts_statut ON emprunts(statut);

-- Trigger pour vérifier la disponibilité avant insertion
DELIMITER $$
CREATE TRIGGER before_emprunt_insert
BEFORE INSERT ON emprunts
FOR EACH ROW
BEGIN
    DECLARE disponibilite INT;
    
    -- Vérifier la disponibilité du livre
    SELECT exemplaires_disponibles INTO disponibilite
    FROM livres WHERE id = NEW.livre_id;
    
    IF disponibilite <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le livre n\'est pas disponible';
    END IF;
    
    -- Mettre à jour la disponibilité
    UPDATE livres 
    SET exemplaires_disponibles = exemplaires_disponibles - 1
    WHERE id = NEW.livre_id;
END$$
DELIMITER ;

-- Trigger pour mettre à jour la disponibilité après retour
DELIMITER $$
CREATE TRIGGER after_emprunt_update
AFTER UPDATE ON emprunts
FOR EACH ROW
BEGIN
    IF NEW.statut = 'RETOURNE' AND OLD.statut != 'RETOURNE' THEN
        -- Incrémenter la disponibilité du livre
        UPDATE livres 
        SET exemplaires_disponibles = exemplaires_disponibles + 1
        WHERE id = NEW.livre_id;
    END IF;
END$$
DELIMITER ;