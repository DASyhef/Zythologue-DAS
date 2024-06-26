# Zythologue-DAS

1- Lister les bières par taux d'alcool, de la plus légère à la plus forte :
SELECT * FROM beer ORDER BY ABV_Bieres ASC;

2- Afficher le nombre de bières par catégorie :
SELECT bc.Name_beer_category, COUNT(*) AS Nombre_de_bieres
FROM beer b
INNER JOIN beer_category bc ON b.ID_beer_category = bc.ID_beer_category
GROUP BY bc.Name_beer_category;

3- Trouver toutes les bières d'une brasserie donnée :
SELECT * FROM beer WHERE ID_brewery = <ID_de_la_brasserie>;
ou
SELECT beer.*
FROM beer
JOIN brewery ON beer.ID_brewery = brewery.ID_brewery
WHERE brewery.Name_brewery = 'Nom_de_la_brasserie';

4- Lister les utilisateurs et le nombre de bières qu'ils ont ajoutées à leurs favoris :
SELECT u.Name_users, COUNT(l.ID_beer) AS Nombre_de_bieres_favorites
FROM users u
LEFT JOIN likes l ON u.ID_users = l.ID_users
GROUP BY u.Name_users;

5- Ajouter une nouvelle bière à la base de données :
INSERT INTO beer (Name_beer, Description_Bieres, ABV_Bieres, Creation_Date_beer, Modification_Date_beer, ID_brewery, ID_beer_category)
VALUES ('Nom_de_la_biere', 'Description_de_la_biere', 'ABV_de_la_biere', NOW(), NOW(), 'ID_de_la_brasserie', 'ID_de_la_categorie');

6- Afficher les bières et leurs brasseries, ordonnées par pays de la brasserie :
SELECT b.*, br.Name_brewery, br.Country_brewery
FROM beer b
INNER JOIN brewery br ON b.ID_brewery = br.ID_brewery
ORDER BY br.Country_brewery;

7- Lister les bières avec leurs ingrédients :
SELECT b.*
FROM beer b
INNER JOIN contain c ON b.ID_beer = c.ID_beer
INNER JOIN ingredient i ON c.ID_ingredient = i.ID_ingredient
WHERE i.Name_ingredient = 'Sucre Candi';

8- Afficher les brasseries et le nombre de bières qu'elles produisent, pour celles ayant plus de 5 bières :
SELECT br.*, COUNT(b.ID_beer) AS Nombre_de_bieres
FROM brewery br
INNER JOIN beer b ON br.ID_brewery = b.ID_brewery
GROUP BY br.ID_brewery
HAVING COUNT(b.ID_beer) > 5;

9- Lister les bières qui n'ont pas encore été ajoutées aux favoris par aucun utilisateur :
SELECT b.*
FROM beer b
LEFT JOIN likes l ON b.ID_beer = l.ID_beer
WHERE l.ID_beer IS NULL;

10- Trouver les bières favorites communes entre deux utilisateurs :
SELECT l1.ID_beer
FROM likes l1
INNER JOIN likes l2 ON l1.ID_beer = l2.ID_beer
WHERE l1.ID_users = <ID_utilisateur_1> AND l2.ID_users = <ID_utilisateur_2>;

11- Afficher les brasseries dont les bières ont une moyenne des notes supérieure à une certaine valeur :
SELECT br.*, AVG(c.note_comment) AS Moyenne_des_notes
FROM brewery br
INNER JOIN beer b ON br.ID_brewery = b.ID_brewery
INNER JOIN comment c ON b.ID_beer = c.ID_beer
GROUP BY br.ID_brewery
HAVING AVG(c.note_comment) > <valeur>;

12- Mettre à jour les informations d'une brasserie :
UPDATE brewery
SET Name_brewery = 'Nouveau_nom', Country_brewery = 'Nouveau_pays'
WHERE ID_brewery = <ID_de_la_brasserie>;

13- Supprimer les photos d'une bière en particulier :
DELETE FROM photo WHERE ID_beer = <ID_de_la_biere>;
