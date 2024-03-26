-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : database
-- Généré le : mar. 26 mars 2024 à 15:07
-- Version du serveur : 8.2.0
-- Version de PHP : 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `zythologie`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`%` PROCEDURE `NoterBiere` (IN `p_ID_users` INT, IN `p_ID_beer` INT, IN `p_note` DECIMAL(10,0))   BEGIN
    DECLARE v_existing_note DECIMAL(10,0);

    -- Vérifier si l'utilisateur a déjà noté cette bière
    SELECT note_comment INTO v_existing_note
    FROM comment
    WHERE ID_users = p_ID_users AND ID_beer = p_ID_beer;

    IF v_existing_note IS NOT NULL THEN
        -- Mettre à jour la note existante
        UPDATE comment
        SET note_comment = p_note,
            Modification_Date_comment = NOW()
        WHERE ID_users = p_ID_users AND ID_beer = p_ID_beer;
    ELSE
        -- Insérer une nouvelle note
        INSERT INTO comment (ID_users, ID_beer, note_comment, Creation_Date_comment)
        VALUES (p_ID_users, p_ID_beer, p_note, NOW());
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `beer`
--

CREATE TABLE `beer` (
  `ID_beer` int NOT NULL,
  `Name_beer` varchar(144) DEFAULT NULL,
  `Description_Bieres` text,
  `ABV_Bieres` decimal(10,0) DEFAULT NULL,
  `Creation_Date_beer` datetime DEFAULT NULL,
  `Modification_Date_beer` datetime DEFAULT NULL,
  `ID_brewery` int DEFAULT NULL,
  `ID_beer_category` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `beer`
--

INSERT INTO `beer` (`ID_beer`, `Name_beer`, `Description_Bieres`, `ABV_Bieres`, `Creation_Date_beer`, `Modification_Date_beer`, `ID_brewery`, `ID_beer_category`) VALUES
(1, 'Guinness Draught', 'La Guinness Draught est une stout renommée, célèbre pour sa couleur noire profonde, son goût de torréfaction et sa texture crémeuse.', 4, '2024-03-26 09:44:00', NULL, 1, 1),
(2, 'Leffe Blonde', 'La Leffe Blonde est une bière de couleur dorée avec un arôme fruité et une saveur douce et équilibrée.', 7, '2024-03-26 10:32:25', NULL, 2, 2),
(3, 'Duvel', 'La Duvel est une ale belge rafraîchissante, avec des notes de fruits, d\'épices et une amertume subtile, complétée par une finale sèche et piquante.', 9, '2024-03-26 10:47:44', '2024-03-26 10:47:44', 3, 3),
(4, 'Chimay Bleue', 'La Chimay Bleue est une bière trappiste puissante et complexe, offrant des arômes de fruits mûrs, de caramel et d\'épices, avec une finale chaleureuse.', 9, '2024-03-26 11:56:41', NULL, 4, 2);

--
-- Déclencheurs `beer`
--
DELIMITER $$
CREATE TRIGGER `Check_ABV` BEFORE INSERT ON `beer` FOR EACH ROW BEGIN
    IF NEW.ABV_Bieres < 0 OR NEW.ABV_Bieres > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Le taux d'alcool (ABV) doit être compris entre 0 et 20";
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `beer_category`
--

CREATE TABLE `beer_category` (
  `ID_beer_category` int NOT NULL,
  `Name_beer_category` varchar(144) DEFAULT NULL,
  `Creation_Date_beer_category` datetime DEFAULT NULL,
  `Modification_Date_beer_category` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `beer_category`
--

INSERT INTO `beer_category` (`ID_beer_category`, `Name_beer_category`, `Creation_Date_beer_category`, `Modification_Date_beer_category`) VALUES
(1, 'Stout', '2024-03-26 09:50:54', NULL),
(2, ' Ale belge', '2024-03-26 10:34:03', NULL),
(3, 'Strong Pale Ale', '2024-03-26 11:51:34', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `brewery`
--

CREATE TABLE `brewery` (
  `ID_brewery` int NOT NULL,
  `Name_brewery` varchar(255) DEFAULT NULL,
  `Country_brewery` varchar(144) DEFAULT NULL,
  `Creation_Date_brewery` datetime DEFAULT NULL,
  `Modification_Date_brewery` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `brewery`
--

INSERT INTO `brewery` (`ID_brewery`, `Name_brewery`, `Country_brewery`, `Creation_Date_brewery`, `Modification_Date_brewery`) VALUES
(1, 'Guinness Brewery', 'Irlande', '2024-03-26 09:49:19', NULL),
(2, 'Abbaye de Leffe', 'Belgique', '2024-03-26 10:37:18', NULL),
(3, 'Brasserie Duvel Moortgat', 'Belgique', '2024-03-26 11:49:12', NULL),
(4, 'Abbaye Notre-Dame de Scourmont', 'Belgique', '2024-03-26 12:03:36', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `comment`
--

CREATE TABLE `comment` (
  `ID_users` int NOT NULL,
  `ID_beer` int NOT NULL,
  `ID_comment` int DEFAULT NULL,
  `Comment_comment` text,
  `note_comment` decimal(10,0) DEFAULT NULL,
  `Creation_Date_comment` datetime DEFAULT NULL,
  `Modification_Date_comment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `comment`
--

INSERT INTO `comment` (`ID_users`, `ID_beer`, `ID_comment`, `Comment_comment`, `note_comment`, `Creation_Date_comment`, `Modification_Date_comment`) VALUES
(1, 3, 1, 'La calotte de ses morts, que c\'est la bière du Housmann !\r\n2022 c\'est bientôt la fin du monde, vous allez tous la boire !', 5, '2024-03-26 12:17:56', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `contain`
--

CREATE TABLE `contain` (
  `ID_beer` int NOT NULL,
  `ID_ingredient` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `contain`
--

INSERT INTO `contain` (`ID_beer`, `ID_ingredient`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(1, 4),
(2, 4),
(3, 4),
(4, 4),
(2, 5),
(4, 6),
(3, 7);

-- --------------------------------------------------------

--
-- Structure de la table `ingredient`
--

CREATE TABLE `ingredient` (
  `ID_ingredient` int NOT NULL,
  `Type_Avis` varchar(255) DEFAULT NULL,
  `Name_ingredient` varchar(144) DEFAULT NULL,
  `Creation_Date_ingredient` datetime DEFAULT NULL,
  `Modification_Date_ingredient` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ingredient`
--

INSERT INTO `ingredient` (`ID_ingredient`, `Type_Avis`, `Name_ingredient`, `Creation_Date_ingredient`, `Modification_Date_ingredient`) VALUES
(1, 'test', 'Eau', '2024-03-26 10:20:23', NULL),
(2, 'Test', 'Malt d\'orge', '2024-03-26 10:26:25', NULL),
(3, 'Test', 'Houblon', '2024-03-26 10:27:31', NULL),
(4, 'Test', 'Levure', '2024-03-26 10:28:31', NULL),
(5, 'Test 2', 'Maïs', '2024-03-26 10:45:11', NULL),
(6, 'test 3', 'Sucre Candi', '2024-03-26 11:54:49', NULL),
(7, 'Test 4', 'Sucre', '2024-03-26 11:55:09', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `likes`
--

CREATE TABLE `likes` (
  `ID_users` int NOT NULL,
  `ID_beer` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `photo`
--

CREATE TABLE `photo` (
  `ID_photo` int NOT NULL,
  `URL_Photos` varchar(500) DEFAULT NULL,
  `Creation_Date_photo` datetime DEFAULT NULL,
  `Modification_Date_photo` datetime DEFAULT NULL,
  `ID_beer` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `photo`
--

INSERT INTO `photo` (`ID_photo`, `URL_Photos`, `Creation_Date_photo`, `Modification_Date_photo`, `ID_beer`) VALUES
(1, 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcQl-UrSv-uTKeqvgrKxT9NGgLrKUwNy4mZ3AaPrItrOW4eVoJ5Bei6OxYVN19ep9Vw3xaeY7zsWmWaBnNdyvjC8vdAKEw09vQlskb2DwwU722cPqMcbebU_eg', '2024-03-26 10:41:59', NULL, 1),
(2, 'https://www.maitre-georges.com/2165-large_default/biere-belge-abbaye-de-leffe-blonde-75-cl.jpg', '2024-03-26 10:43:35', NULL, 2),
(3, 'https://media.auchan.fr/A0220140520000569270PRIMARY_1200x1200/B2CD/', '2024-03-26 12:15:27', NULL, 3),
(4, 'https://www.drinks-explorer.com/766-large_default/biere-chimay-bleue.jpg', '2024-03-26 12:15:27', NULL, 4);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `ID_users` int NOT NULL,
  `Name_users` varchar(255) DEFAULT NULL,
  `EMail` varchar(255) DEFAULT NULL,
  `Password_Utilisateurs` varchar(144) DEFAULT NULL,
  `Creation_Date_users` datetime DEFAULT NULL,
  `Modification_Date_users` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`ID_users`, `Name_users`, `EMail`, `Password_Utilisateurs`, `Creation_Date_users`, `Modification_Date_users`) VALUES
(1, 'David Lopez', 'oujoujemorts@lacalotte.com', 'Oujoujémorts', '2024-03-26 12:16:45', NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `beer`
--
ALTER TABLE `beer`
  ADD PRIMARY KEY (`ID_beer`),
  ADD KEY `FK_beer_ID_brewery` (`ID_brewery`),
  ADD KEY `FK_beer_ID_beer_category` (`ID_beer_category`);

--
-- Index pour la table `beer_category`
--
ALTER TABLE `beer_category`
  ADD PRIMARY KEY (`ID_beer_category`);

--
-- Index pour la table `brewery`
--
ALTER TABLE `brewery`
  ADD PRIMARY KEY (`ID_brewery`);

--
-- Index pour la table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`ID_users`,`ID_beer`),
  ADD KEY `FK_comment_ID_beer` (`ID_beer`);

--
-- Index pour la table `contain`
--
ALTER TABLE `contain`
  ADD PRIMARY KEY (`ID_beer`,`ID_ingredient`),
  ADD KEY `FK_contain_ID_ingredient` (`ID_ingredient`);

--
-- Index pour la table `ingredient`
--
ALTER TABLE `ingredient`
  ADD PRIMARY KEY (`ID_ingredient`);

--
-- Index pour la table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`ID_users`,`ID_beer`),
  ADD KEY `FK_like_ID_beer` (`ID_beer`);

--
-- Index pour la table `photo`
--
ALTER TABLE `photo`
  ADD PRIMARY KEY (`ID_photo`),
  ADD KEY `FK_photo_ID_beer` (`ID_beer`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID_users`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `beer`
--
ALTER TABLE `beer`
  MODIFY `ID_beer` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `beer_category`
--
ALTER TABLE `beer_category`
  MODIFY `ID_beer_category` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `brewery`
--
ALTER TABLE `brewery`
  MODIFY `ID_brewery` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `comment`
--
ALTER TABLE `comment`
  MODIFY `ID_users` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `contain`
--
ALTER TABLE `contain`
  MODIFY `ID_beer` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `ingredient`
--
ALTER TABLE `ingredient`
  MODIFY `ID_ingredient` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `likes`
--
ALTER TABLE `likes`
  MODIFY `ID_users` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `photo`
--
ALTER TABLE `photo`
  MODIFY `ID_photo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `ID_users` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `beer`
--
ALTER TABLE `beer`
  ADD CONSTRAINT `FK_beer_ID_beer_category` FOREIGN KEY (`ID_beer_category`) REFERENCES `beer_category` (`ID_beer_category`),
  ADD CONSTRAINT `FK_beer_ID_brewery` FOREIGN KEY (`ID_brewery`) REFERENCES `brewery` (`ID_brewery`);

--
-- Contraintes pour la table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`ID_users`) REFERENCES `users` (`ID_users`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`ID_beer`) REFERENCES `beer` (`ID_beer`),
  ADD CONSTRAINT `FK_comment_ID_beer` FOREIGN KEY (`ID_beer`) REFERENCES `beer` (`ID_beer`),
  ADD CONSTRAINT `FK_comment_ID_users` FOREIGN KEY (`ID_users`) REFERENCES `users` (`ID_users`);

--
-- Contraintes pour la table `contain`
--
ALTER TABLE `contain`
  ADD CONSTRAINT `contain_ibfk_1` FOREIGN KEY (`ID_beer`) REFERENCES `beer` (`ID_beer`),
  ADD CONSTRAINT `contain_ibfk_2` FOREIGN KEY (`ID_ingredient`) REFERENCES `ingredient` (`ID_ingredient`),
  ADD CONSTRAINT `FK_contain_ID_beer` FOREIGN KEY (`ID_beer`) REFERENCES `beer` (`ID_beer`),
  ADD CONSTRAINT `FK_contain_ID_ingredient` FOREIGN KEY (`ID_ingredient`) REFERENCES `ingredient` (`ID_ingredient`);

--
-- Contraintes pour la table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `FK_like_ID_beer` FOREIGN KEY (`ID_beer`) REFERENCES `beer` (`ID_beer`),
  ADD CONSTRAINT `FK_like_ID_users` FOREIGN KEY (`ID_users`) REFERENCES `users` (`ID_users`),
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`ID_users`) REFERENCES `users` (`ID_users`),
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`ID_beer`) REFERENCES `beer` (`ID_beer`);

--
-- Contraintes pour la table `photo`
--
ALTER TABLE `photo`
  ADD CONSTRAINT `FK_photo_ID_beer` FOREIGN KEY (`ID_beer`) REFERENCES `beer` (`ID_beer`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
