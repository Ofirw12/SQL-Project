CREATE TABLE Customers(
Username VARCHAR(20) NOT NULL,
[Password] VARCHAR(20) NOT NULL,
[Phone Number] VARCHAR(15) NOT NULL,
Country VARCHAR(20) NOT NULL,
City VARCHAR(50) NOT NULL,
Street VARCHAR(50) NOT NULL,
[House Number] INT NOT NULL,
Apartment INT,
Email VARCHAR(50) NOT NULL,
CONSTRAINT PK_Customers PRIMARY KEY (Username),
CONSTRAINT CK_Email CHECK ([Email] LIKE '%@%.%'),
CONSTRAINT CK_PhoneNum CHECK ([Phone Number] LIKE '+%')
)

CREATE TABLE [Payment Methods](
[Credit Number] VARCHAR(20) NOT NULL,
[Expiration Date] DATE NOT NULL,
CVC VARCHAR(3) NOT NULL,
CONSTRAINT PK_PMethods PRIMARY KEY ([Credit Number]),
CONSTRAINT CK_ExpDate CHECK ([Expiration Date]> Getdate()),
CONSTRAINT CK_CVC CHECK (CVC LIKE '[0-9][0-9][0-9]')
)

CREATE TABLE Carts(
[Cart ID] INT NOT NULL,
Username VARCHAR(20)
CONSTRAINT PK_Carts PRIMARY KEY ([Cart ID])
CONSTRAINT FK_Carts FOREIGN KEY (Username) REFERENCES Customers(Username)
)

CREATE TABLE Orders(
[Order ID] INT NOT NULL,
[Date] DATE NOT NULL,
[Credit Card] VARCHAR(20) NOT NULL,
Cart INT NOT NULL,
CONSTRAINT PK_Orders PRIMARY KEY ([Order ID]),
CONSTRAINT FK_Orders FOREIGN KEY (Cart) REFERENCES Carts([Cart ID]),
CONSTRAINT FK_Orders1 FOREIGN KEY ([Credit Card]) REFERENCES [Payment Methods]([Credit Number])
)

CREATE TABLE [Sock Types](
[Type] INT NOT NULL,
CONSTRAINT PK_STypes PRIMARY KEY ([Type])
)

CREATE TABLE Socks(
[Sock ID] INT NOT NULL,
[Type] VARCHAR(20) NOT NULL,
CONSTRAINT PK_Socks PRIMARY KEY ([Sock ID]),
CONSTRAINT FK_Socks FOREIGN KEY ([Sock ID]) REFERENCES [Sock Types](Type) ,
)

CREATE TABLE Colors(
Color VARCHAR(15) NOT NULL
CONSTRAINT PK_Colors PRIMARY KEY (Color)
)

CREATE TABLE Designs(
[Sock ID] INT NOT NULL,
[Design ID] INT NOT NULL,
Height VARCHAR(15) NOT NULL,
Color VARCHAR(15) NOT NULL,
Size VARCHAR(10) NOT NULL,
Cost MONEY DEFAULT 8.99 NOT NULL,
CONSTRAINT PK_Designs PRIMARY KEY ([Sock ID],[Design ID]),
CONSTRAINT FK_Designs FOREIGN KEY ([Sock ID]) REFERENCES Socks([Sock ID]),
CONSTRAINT FK_Designs2 FOREIGN KEY (Color) REFERENCES Colors(Color)
)



CREATE TABLE [Design Templates](
[Sock ID] INT NOT NULL,
[Design ID] INT NOT NULL,
Area VARCHAR(15) NOT NULL,
[Template Type] VARCHAR(15) NOT NULL,
Color VARCHAR(15) DEFAULT 'BLACK' NOT NULL,
CONSTRAINT PK_DTemplates PRIMARY KEY ([Sock ID],[Design ID],Area,[Template Type],Color),
CONSTRAINT FK_DTemplates FOREIGN KEY ([Sock ID],[Design ID]) REFERENCES Designs([Sock ID],[Design ID]),
CONSTRAINT FK_DTemplates2 FOREIGN KEY (Color) REFERENCES Colors(Color)
)

CREATE TABLE [Design Texts](
[Sock ID] INT NOT NULL,
[Design ID] INT NOT NULL,
[Text] VARCHAR(20) NOT NULL,
Color VARCHAR(15) DEFAULT 'BLACK' NOT NULL,
Size VARCHAR(5) NOT NULL,
CONSTRAINT PK_DTexts PRIMARY KEY ([Sock ID],[Design ID],Color,Size,[Text]),
CONSTRAINT FK_DTexts FOREIGN KEY ([Sock ID],[Design ID]) REFERENCES Designs([Sock ID],[Design ID]),
CONSTRAINT FK_DTexts2 FOREIGN KEY (Color) REFERENCES Colors(Color)
)

CREATE TABLE [Design Uploaded Photos](
[Sock ID] INT NOT NULL,
[Design ID] INT NOT NULL,
Photo VARCHAR(1000) NOT NULL,
CONSTRAINT PK_DMaterials PRIMARY KEY ([Sock ID],[Design ID],Photo),
CONSTRAINT FK_DMaterials FOREIGN KEY ([Sock ID],[Design ID]) REFERENCES Designs([Sock ID],[Design ID])
)

CREATE TABLE [Socks Saved To Carts](
[Sock ID] INT NOT NULL,
[Design ID] INT NOT NULL,
Cart INT NOT NULL,
CONSTRAINT PK_SSTCarts PRIMARY KEY ([Sock ID],[Design ID],Cart),
CONSTRAINT FK_SSTCarts FOREIGN KEY (Cart) REFERENCES Carts([Cart ID]),
CONSTRAINT FK_SSTCarts2 FOREIGN KEY ([Sock ID],[Design ID]) REFERENCES Designs([Sock ID],[Design ID])
)

CREATE TABLE [Customer's Payment Info](
Username VARCHAR(20) NOT NULL,
[Credit Number] VARCHAR(20) NOT NULL,
CONSTRAINT PK_CPInfo PRIMARY KEY (Username,[Credit Number]),
CONSTRAINT FK_CPInfo FOREIGN KEY (Username) REFERENCES Customers(Username),
CONSTRAINT FK_CPInfo2 FOREIGN KEY ([Credit Number]) REFERENCES [Payment Methods]([Credit Number])
)

--DROP TABLE [Customer's Payment Info]
--DROP TABLE [Socks Saved To Carts]
--DROP TABLE [Design Uploaded Photos]
--DROP TABLE [Design Texts]
--DROP TABLE [Design Templates]
--DROP TABLE Designs
--DROP TABLE Colors
--DROP TABLE Socks
--DROP TABLE [Sock Types]
--DROP TABLE Orders
--DROP TABLE Carts
--DROP TABLE [Payment Methods]
--DROP TABLE Customers
