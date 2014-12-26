
/*
    Papéis: Administrador, Consumidor, Funcionário do Supermercado
    Serão gerenciados pela aplicação.
*/

-- Tabela de usuários com dados básicos para acesso
CREATE TABLE Users (
    Id INT IDENTITY (1,1) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR (320) NOT NULL,
    ProfileImageName VARCHAR (250) NULL,
	Token VARCHAR(500) NOT NULL,
    CreatedDateTime DATETIME NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (Id)
)

-- Tabela de mercados
CREATE TABLE Markets (
	Id INT IDENTITY (1,1) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	SegmentId TINYINT NOT NULL, -- Supermercados: 1; Distribuidoras: 2; Açogues: 3 ...
	IsActive BIT DEFAULT(1),
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT PK_Markets PRIMARY KEY (Id)
)

-- Tabela de funcionários do supermercado com dados para controle de acesso
CREATE TABLE MarketEmployee (
	UserId INT NOT NULL,
	MarketId INT NOT NULL,
	IsActive BIT NOT NULL,
	IsTempPassword BIT NOT NULL,
	HasFullAccess BIT DEFAULT(0),
	CanRegisterOfferInAnyStore BIT DEFAULT(1),
	CONSTRAINT FK_MarketEmployee_Users FOREIGN KEY (UserId) REFERENCES Users(Id),
	CONSTRAINT FK_MarketEmployee_Market FOREIGN KEY (MarketId) REFERENCES Markets(Id)
)

-- Tabela de lojas do mercado
CREATE TABLE MarketStores (
	Id INT IDENTITY (1,1) NOT NULL,
	MarketId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	FullAddress VARCHAR(500) NOT NULL,
	DistrictName VARCHAR(100) NOT NULL,
	CityName VARCHAR(100) NOT NULL,
	StateName VARCHAR(100) NOT NULL,
	CountryName VARCHAR(100) NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT PK_MarketStores PRIMARY KEY (Id),
	CONSTRAINT FK_MarketStores_Market FOREIGN KEY (MarketId) REFERENCES Markets(Id)
)

-- Tabela de produtos
CREATE TABLE Products (
	Id INT IDENTITY (1,1) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	ImageFileName VARCHAR(60) NOT NULL,
	CONSTRAINT PK_Products PRIMARY KEY (Id)
)

-- Tabela de Categorias da Oferta
CREATE TABLE Categories (
	Id INT IDENTITY (1,1) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	CONSTRAINT PK_Categories PRIMARY KEY (Id)
)

-- Tabela de ofertas
CREATE TABLE Offers (
	Id BIGINT IDENTITY (1,1) NOT NULL,
	MarketId INT NOT NULL,
	ProductId INT NOT NULL,
	CategoryId INT NOT NULL,
	PriceOf MONEY NOT NULL,
	PriceFor MONEY NOT NULL,
	ExpirationDate DATE NOT NULL,
	IsValidForAllMarkets BIT DEFAULT(1),
	[Description] VARCHAR(100) NOT NULL,
	StartDate DATE NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT PK_Offers PRIMARY KEY (Id),
	CONSTRAINT FK_Offers_Market FOREIGN KEY (MarketId) REFERENCES Markets(Id),
	CONSTRAINT FK_Offers_Product FOREIGN KEY (ProductId) REFERENCES Products(Id),
	CONSTRAINT FK_Offers_Category FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)

-- Tabela de ofertas relacionadas às lojas, para casos em que a oferta é válida para lojas específicas
CREATE TABLE MarketStoreOffers (
	OfferId BIGINT NOT NULL,
	MarketStoreId INT NOT NULL,
	CONSTRAINT FK_MarketStoreOffers_Offer FOREIGN KEY (OfferId) REFERENCES Offers(Id),
	CONSTRAINT FK_MarketStoreOffers_MarketStore FOREIGN KEY (MarketStoreId) REFERENCES MarketStores(Id)
)

-- Tabela que registra as visualizações que o usuário teve na oferta
CREATE TABLE OfferViews (
	OfferId BIGINT NOT NULL,
	CustomerId INT NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT FK_OfferViews_Offer FOREIGN KEY (OfferId) REFERENCES Offers(Id),
	CONSTRAINT FK_OfferViews_Users FOREIGN KEY (CustomerId) REFERENCES Users(Id)
)

-- Tabela que registra as preferências do consumidor
-- CustomerProfileId: 1 - Work, 2 - NearHome, 3 - LoveOffers
CREATE TABLE CustomerPreferences (
	CustomerId INT NOT NULL,
	CustomerProfileId TINYINT NOT NULL,
	WorkFullAddress VARCHAR(500) NULL,
	WorkDistrict VARCHAR(100) NULL,
	WorkCity VARCHAR(100) NULL,
	WorkState VARCHAR(100) NULL,
	HomeFullAddress VARCHAR(500) NULL,
	HomeDistrict VARCHAR(100) NULL,
	HomeCity VARCHAR(100) NULL,
	HomeState VARCHAR(100) NULL,
	ReceiveAllDays BIT DEFAULT(1),
	ReceiveAnyDayPeriod BIT DEFAULT(1),
	ModifiedDateTime DATETIME NOT NULL,
	CONSTRAINT FK_CustomerPreferences_Users FOREIGN KEY (CustomerId) REFERENCES Users(Id)
)

-- Tabela que armazena os dias específicos que o usuário deseja receber ofertas
-- DayId: 1 - Domingo, 2 - Segunda, 3 - Terça, 4 - Quarta, 5 - Quinta, 6 - Sexta - 7 - Sábado
CREATE TABLE ReceiveDaysPreference (
	CustomerId INT NOT NULL,
	DayId TINYINT,
	CONSTRAINT FK_ReceiveDaysPreference_Users FOREIGN KEY (CustomerId) REFERENCES Users(Id)
)

-- Tabela que armazena o período do dia específico que o usuário deseja receber ofertas
-- DayPeriodId: 1 - Manhã, 2 - Tarde, 3 - Noite
CREATE TABLE ReceivePeriodsDayPreference (
	CustomerId INT NOT NULL,
	DayPeriodId TINYINT NOT NULL,
	CONSTRAINT FK_ReceivePeriodsDayPreference_Users FOREIGN KEY (CustomerId) REFERENCES Users(Id)
)

-- Tabela de ofertas patrocinadas pelo mercado para ganhar destaque
CREATE TABLE SponsoredOffers (
	Id INT IDENTITY (1,1) NOT NULL,
	OfferId BIGINT NOT NULL,
	MarketId INT NOT NULL,
	AgeRangeOf SMALLINT NULL,
	AgeRangeFor SMALLINT NULL,
	AllDistricts BIT DEFAULT(1),
	Districts VARCHAR(500) NULL, --Bairros separados por vírgula
	SponsoredDays SMALLINT NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	TotalPrice MONEY NOT NULL,
	CONSTRAINT PK_SponsoredOffers PRIMARY KEY (Id),
	CONSTRAINT FK_SponsoredOffers_Offer FOREIGN KEY (OfferId) REFERENCES Offers(Id),
	CONSTRAINT FK_SponsoredOffers_Market FOREIGN KEY (MarketId) REFERENCES Markets(Id)
)

-- Tabela de assinaturas dos mercados
CREATE TABLE MarketSubscriptions (
	Id INT IDENTITY (1,1) NOT NULL,
	MarketId INT NOT NULL,
	IsActive BIT NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT PK_MarketSubscriptions PRIMARY KEY (Id),
	CONSTRAINT FK_MarketSubscriptions_Market FOREIGN KEY (MarketId) REFERENCES Markets(Id)
)

 -- Tabela de ofertas favoritas do consumidor
 CREATE TABLE FavoriteCustomerOffers (
	Id INT IDENTITY (1,1) NOT NULL,
	CustomerId INT NOT NULL,
	OfferId BIGINT NOT NULL,
	IsExpired BIT DEFAULT(0),
	WasPurchased BIT DEFAULT(0),
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT PK_FavoriteCustomerOffers PRIMARY KEY (Id),
	CONSTRAINT FK_FavoriteCustomerOffers_User FOREIGN KEY (CustomerId) REFERENCES Users(Id),
	CONSTRAINT FK_FavoriteCustomerOffers_Offer FOREIGN KEY (OfferId) REFERENCES Offers(Id)
 )
 
 -- Tabela que registra a compra do consumidor
 CREATE TABLE CustomerPurchases (
	Id INT IDENTITY (1,1) NOT NULL,
	CustomerId INT NOT NULL,	
	Quantity SMALLINT NOT NULL,
	TotalPrice MONEY NOT NULL,
	SavedPrice MONEY NOT NULL, --economia que foi feita no total da compra, tendo em vista o preço de das ofertas
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT PK_CustomerPurchases PRIMARY KEY (Id),
	CONSTRAINT FK_CustomerPurchases_User FOREIGN KEY (CustomerId) REFERENCES Users(Id),
	
)

-- Tabela com as ofertas que foram compradas pelo consumidor
CREATE TABLE CustomerPurchOffers (
	PurchId INT NOT NULL,
	OfferId BIGINT NOT NULL,
	CONSTRAINT FK_CustomerPurchOffers_Purch FOREIGN KEY (PurchId) REFERENCES CustomerPurchases(Id),
	CONSTRAINT FK_CustomerPurchOffers_Offer FOREIGN KEY (OfferId) REFERENCES Offers(Id)
)

-- Tabela de pontos do consumidor, que registra créditos ou débito de pontos
CREATE TABLE CustomerPointsStatement (
	Id INT IDENTITY (1,1) NOT NULL,
	CustomerId INT NOT NULL,
	PurchId INT NULL,
	Points INT NULL,
	IsCredit BIT NOT NULL,
	CONSTRAINT PK_CustomerPointsStatement PRIMARY KEY (Id),
	CONSTRAINT FK_CustomerPointsStatement_User FOREIGN KEY (CustomerId) REFERENCES Users(Id),
	CONSTRAINT FK_CustomerPointsStatement_CustomerPurchases FOREIGN KEY (PurchId) REFERENCES CustomerPurchases(Id),
)

-- Tabela de pagamentos da assinatura do mercado
-- PaymentStatusId: 1 - Aguardando Pagamento, 2 - Pago, 3 - Cancelado
-- GatewayTypeId: 1 - PagSeguro, 2 - Boleto
CREATE TABLE MarketPayments (
	Id INT IDENTITY (1,1) NOT NULL,
	MarketId INT NOT NULL,
	PaymentStatusId TINYINT NOT NULL,
	GatewayTypeId TINYINT NOT NULL,
	TotalPrice MONEY NOT NULL,
	SubscriptionMonth DATE NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	CONSTRAINT PK_MarketPayments PRIMARY KEY (Id),
	CONSTRAINT FK_MarketPayments_Market FOREIGN KEY (MarketId) REFERENCES Markets(Id)
)

-- Arquivos temporários.
CREATE TABLE TempFiles (
	Id INT IDENTITY (1, 1) NOT NULL,
	[FileName] VARCHAR(40) NOT NULL,
	FileType TINYINT NOT NULL,
    ToBeDeleted BIT NOT NULL,
    IsDeleted BIT NOT NULL,
    
	CreatedDateTime DATETIME NOT NULL,

    CONSTRAINT PK_TempFiles PRIMARY KEY (Id)
)

/****************************************
*
*           PendingEmails
*
****************************************/

-- E-mails pendentes de envio.
CREATE TABLE PendingEmails (
	Id INT IDENTITY PRIMARY KEY NOT NULL,
	CreatedDateTime DATETIME NOT NULL,
	ErrorMessage VARCHAR(500) NULL,
	LastTryDateTime DATETIME NULL,
	MessageSubject VARCHAR(100) NULL,
	MessageText VARCHAR(MAX) NULL,
	ToAddresses VARCHAR(2000) NOT NULL,
	ToNames VARCHAR(1000) NOT NULL,
	TryCount TINYINT NOT NULL)

/****************************************
*
*     CEP / CIDADES / ESTADOS / PAÍSES
*
****************************************/

-- Países
CREATE TABLE CountryRegions (
	Code CHAR(3) PRIMARY KEY NOT NULL,
	Name VARCHAR(50) NOT NULL
)
GO


-- Estados
CREATE TABLE StateProvinces (
	CountryRegionCode CHAR(3) NOT NULL,
	Id INT IDENTITY (1, 1) NOT NULL,
	Code VARCHAR(3) NOT NULL,
	Name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_StateProvinces PRIMARY KEY (Id),
	CONSTRAINT FK_StateProvinces_CountryRegions FOREIGN KEY (CountryRegionCode) REFERENCES CountryRegions(Code)
)
GO


-- Cidades
CREATE TABLE Cities (
	Id INT IDENTITY NOT NULL,
	StateId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Cities PRIMARY KEY (Id),
	CONSTRAINT FK_Cities_StateProvinces FOREIGN KEY (StateId) REFERENCES StateProvinces(Id)
)
GO

