INSERT INTO [Sock Types]
VALUES (1),(2),(3),(4),(5)

INSERT INTO [Payment Methods]
VALUES
('5320 8127 5883 7777','02-28-2024',772),
('4539 0280 9860 0920','03-31-2023', 954),
('4532 8222 8164 3771','07-31-2026', 675),
('4532 7055 8936 1271','05-31-2025',983),
('4716 7950 5345 0898','04-30-2023',235);

INSERT INTO Customers
VALUES
	('AbdulHamidElJabar','iloveAllah','+96654856475','Saudi Arabia', 'Riyadh','Armam', 3,2,'AbdulH@gmail.com'),
	('Oscar_Harvey','mauris','+9728738260','Turkey','aliquam eu', 'accumsan sed', 2 ,4,'aliquet.lobortis@aol.com'),
	('Yeo_Vang','porttitorero','+9728738260','Costa Rica','aliquyf','est. Mauris eu turpis',5,NULL,'natoque.penatibus@hotmail.co.uk'),
	('Inga_Steele','ilovemyparents', '+7457354633','Singapore','tempus non', 'lacinia at',3,77,'elit.curabitur@aol.co.uk'),
	('Joe.Mama','am#%@lorem','+3096699583','Turkey','lobortis','3772 Cras Avenue',3,NULL,'velit.in@icloud.org');

INSERT INTO Carts
VALUES
(1,'AbdulHamidElJabar'),
(2,'Oscar_Harvey'),
(3,NULL),
(4,'Yeo_Vang'),
(5,'Joe.Mama'),
(6,'AbdulHamidElJabar')

INSERT INTO Orders
VALUES
(1,'10-08-2018','5320 8127 5883 7777',2),
(2,'12-08-2019','4532 7055 8936 1271',1),
(3,'05-21-2017','4532 7055 8936 1271',5),
(4,'02-29-2020','4716 7950 5345 0898',4),
(5,'06-09-2016','4532 8222 8164 3771',6);

INSERT INTO Socks
VALUES
(1, 'Standard'),
(2, 'Athletic'),
(3, 'Performance'),
(4, 'Dress'),
(5, 'Print');

INSERT INTO Colors
VALUES
('BLACK'),
('BROWN'),
('DARK GREEN'),
('GOLD'),
('GREY'),
('HOT PINK'),
('KELLY GREEN'),
('MAROON'),
('NAVY BLUE'),
('NEON GREEN'),
('NEON PINK'),
('ORANGE'),
('PINK'),
('PURPLE'),
('RED'),
('ROYAL BLUE'),
('SKY BLUE'),
('TEAL'),
('VEGAS GOLD'),
('WHITE'),
('YELLOW')


INSERT INTO Designs
VALUES
(4, 1, 'Footie', 'NEON GREEN','S' ,8.99),
(2, 2, 'Anklet', 'NAVY BLUE','One Size', 9.99),
(1, 3, 'Crew', 'RED','M', 15.99),
(3, 4, 'Knee-High', 'ORANGE','XL', 10.99),
(5, 5, 'Anklet', 'YELLOW','XL', 8.99);

INSERT INTO [Design Templates]
VALUES
(4, 1,'Top','Stripe','RED'),
(2, 2,'Toe and Heel','Colored','NEON PINK'),
(1, 3,'Top','Stripe - 3','HOT PINK'),
(1, 3,'Toe and Heel', 'Colored','VEGAS GOLD'),
(3, 4,'Top','Stripe - 2','ROYAL BLUE');

INSERT INTO [Design Texts]
VALUES
(1, 3, 'God Bless America', 'WHITE', 'A'),
(4, 1, 'Worst Boss Ever', 'WHITE', 'C'),
(2, 2, 'Best Mom Ever', 'GOLD', 'B'),
(3, 4, 'Sorry', 'WHITE', 'A'),
(5, 5, 'I Love Food', 'WHITE', 'B');

INSERT INTO [Design Uploaded Photos]
VALUES
(4,1,'https://64.media.tumblr.com/297326ed324810b3d57f06d5932b6b30/9e4fb98a00782f7b-5f/s640x960/1686cd67601aa3cec2b3c7fbd2ea1eccf954d919.jpg'),
(2,2,'https://cdn.stips.co.il/photos/w400/4885550778.jpg'),
(1,3,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStYFhjwlny05ZlIZsjmKQnxblZ5JsHU0JP9g&usqp=CAU'),
(3,4,'http://www.2all.co.il/web/Sites/wwwbarak2all/78667_(23).jpg'),
(5,5,'https://cdn.babamail.co.il/Images/2019/4/1/ceba9e10-0a47-4724-87a3-0015559086c2.jpg');

INSERT INTO [Socks Saved To Carts]
VALUES
(2, 2, 1),
(1, 3, 2),
(4, 1, 3),
(5, 5, 4),
(3, 4, 5);

INSERT INTO [Customer's Payment Info]
VALUES
('AbdulHamidElJabar','4532 7055 8936 1271'),
('Oscar_Harvey','5320 8127 5883 7777'),
('Yeo_Vang','4716 7950 5345 0898'),
('Joe.Mama','4532 7055 8936 1271'),
('Inga_Steele','4539 0280 9860 0920');