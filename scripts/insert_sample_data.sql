USE bibliotheque_db;

-- Données de test pour les livres
INSERT INTO livres (titre, auteur, categorie, nombre_exemplaires, exemplaires_disponibles) VALUES
('Le Petit Prince', 'Antoine de Saint-Exupéry', 'Roman', 5, 5),
('1984', 'George Orwell', 'Science-Fiction', 3, 3),
('L\'Étranger', 'Albert Camus', 'Philosophie', 4, 4),
('Harry Potter à l\'école des sorciers', 'J.K. Rowling', 'Fantasy', 6, 6),
('Les Misérables', 'Victor Hugo', 'Classique', 2, 2),
('Germinal', 'Émile Zola', 'Roman', 3, 3),
('Vingt mille lieues sous les mers', 'Jules Verne', 'Aventure', 4, 4);

-- Données de test pour les membres
INSERT INTO membres (nom, prenom, email, adhesion_date, statut) VALUES
('Dupont', 'Jean', 'jean.dupont@email.com', '2024-01-15', 'ACTIF'),
('Martin', 'Marie', 'marie.martin@email.com', '2024-02-20', 'ACTIF'),
('Bernard', 'Pierre', 'pierre.bernard@email.com', '2024-03-10', 'ACTIF'),
('Dubois', 'Sophie', 'sophie.dubois@email.com', '2024-04-05', 'ACTIF'),
('Leroy', 'Thomas', 'thomas.leroy@email.com', '2024-05-12', 'INACTIF');

-- Données de test pour les emprunts
INSERT INTO emprunts (membre_id, livre_id, date_emprunt, date_retour_prevue, date_retour_effective, statut, penalite) VALUES
(1, 1, '2024-05-01', '2024-05-15', '2024-05-14', 'RETOURNE', 0.00),
(2, 3, '2024-05-10', '2024-05-24', NULL, 'EN_COURS', 0.00),
(3, 2, '2024-05-05', '2024-05-19', '2024-05-25', 'RETOURNE', 600.00),
(1, 4, '2024-06-01', '2024-06-15', NULL, 'EN_COURS', 0.00);