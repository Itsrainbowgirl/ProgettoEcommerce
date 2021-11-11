

CREATE SEQUENCE cliente_sq;

CREATE TABLE cliente (
	id INTEGER DEFAULT NEXTVAL ('cliente_sq') PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	cognome VARCHAR(50) NOT NULL,
	telefono VARCHAR(20),
	email VARCHAR(90) NOT NULL,
    indirizzo INTEGER,
    FOREIGN KEY(indirizzo) REFERENCES t_indirizzi(id)
);

CREATE SEQUENCE indirizzi_seq;

CREATE TABLE t_indirizzi(
    id INTEGER DEFAULT NEXTVAL ('indirizzi_seq') PRIMARY KEY,
    cap VARCHAR(5),
    via VARCHAR(90),
    numero_civico INTEGER,
    provincia VARCHAR(70)
);

CREATE SEQUENCE prodotto_seq;

CREATE TABLE prodotto (
	id INTEGER DEFAULT NEXTVAL ('prodotto_seq') PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	bar_code VARCHAR(70) NOT NULL UNIQUE,
	descrizione VARCHAR(500),
	prezzo FLOAT NOT NULL,
	quantita INTEGER NOT NULL,
	immagine VARCHAR(500),
    genere VARCHAR(50),
    version INTEGER

);

CREATE SEQUENCE ordine_seq;

CREATE TABLE ordine (
	id INTEGER DEFAULT NEXTVAL ('ordine_seq') PRIMARY KEY,
	cliente INTEGER,
	purchase_time TIMESTAMP(0) DEFAULT CURRENT_TIMESTAMP,
    pagamento INTEGER,
    FOREIGN KEY(pagamento) REFERENCES pagamento(id),
    FOREIGN KEY (cliente) REFERENCES cliente (id)
);

CREATE SEQUENCE pagamento_seq;

CREATE TABLE pagamento(
    id INTEGER DEFAULT NEXTVAL ('pagamento_seq') PRIMARY KEY,
    numero_carta VARCHAR(16) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    scadenza VARCHAR NOT NULL
);
	
CREATE SEQUENCE carrello_seq;

CREATE TABLE carrello (
	id INTEGER DEFAULT NEXTVAL ('carrello_seq') PRIMARY KEY,
    related_purchase INTEGER,
	prodotto INTEGER,
	quantita INTEGER NOT NULL,
    FOREIGN KEY (related_purchase) REFERENCES ordine (id),
    FOREIGN KEY (prodotto) REFERENCES prodotto (id)
);