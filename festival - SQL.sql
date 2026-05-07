drop database if exists festival;
create database festival;
use festival;

create table Palco(
    ID_Palco int primary key auto_increment,
    Denominazione varchar(100) not null,
    Località varchar(100) not null
);

create table Performance(
    ID_Performance int primary key auto_increment,
    ID_Palco int not null,
    TitoloPerformance varchar(255) not null,
    DataPerformance date not null,

    foreign key(ID_Palco) references Palco(ID_Palco) on delete restrict  #non posso eliminare un palco se associato a un performance
);

create table Staff(
    ID_Staff int primary key auto_increment,
    Nome varchar(255) not null,
    Cognome varchar(255) not null,
    DataNascita date not null,
    CodiceFiscale varchar(16) unique not null,
    ID_Palco int not null,
    Mansione varchar(255) not null,

    foreign key(ID_Palco) references Palco(ID_Palco)
);

create table Spettatore(
    ID_Spettatore int primary key auto_increment,
    Nome varchar(255) not null,
    Cognome varchar(255) not null,
    DataNascita date not null,
    CodiceFiscale varchar(16) unique not null    
);

create table Pagamento(
    ID_Pagamento int primary key auto_increment,
    Importo decimal(10,2) not null,
    Stato enum('In verifica', 'Autorizzato', 'Completato', 'Rifiutato', 'Cancellato') not null,

    check(Importo >= 0)
);

create table Ordine(
    ID_Ordine int primary key auto_increment,
    ID_Pagamento int,
    ID_Spettatore int not null,
    DataOrdine date not null,
    TotaleOrdine decimal(10,2) not null,

    foreign key(ID_Pagamento) references Pagamento(ID_Pagamento) on delete set null, #se elimino un pagamento per un problema il pagamento per l'ordine rimane momentaneamente null
    foreign key(ID_Spettatore) references Spettatore(ID_Spettatore) on delete restrict, #non posso eliminare uno spettatore se associato a un ordine
    check(TotaleOrdine >= 0)
);

create table Biglietto(
    ID_Biglietto int primary key auto_increment,
    ID_Performance int not null,
    ID_Ordine int not null,
    Prezzo decimal(10,2) not null,
    Posto int not null,

    foreign key(ID_Performance) references Performance(ID_Performance) on delete cascade, #se elimino una performance non ha senso mantenere un biglietto associato
    foreign key(ID_Ordine) references Ordine(ID_Ordine) on delete cascade , #se elimino un ordine non ha senso mantenere i biglietti associati
    check(Prezzo > 0),
    check(Posto > 0)
);

create table Artista(
    ID_Artista int primary key auto_increment,
    Nome varchar(255),
    Cognome varchar(255),
    Identificativo varchar(255),
    DataNascita date not null,
    CodiceFiscale varchar(16) unique not null,    
    TipoArtista enum('Singolo', 'Band') not null,
    CHECK( (Nome is not null AND Cognome is not null) OR (Identificativo is not null) )
);

create table Sponsor(
    ID_Sponsor int primary key auto_increment,
    Nome varchar(255) not null
);

create table Sponsorizzazione(
    ID_Sponsorizzazione int primary key auto_increment,
    ID_Sponsor int not null,
    ID_Performance int,
    ID_Artista int,

    foreign key(ID_Sponsor) references Sponsor(ID_Sponsor) on delete cascade, #se elimino uno sponsor non c'è la sponsorizzazione
    foreign key(ID_Performance) references Performance(ID_Performance) on delete set null, #se elimino una performance al momento lo sponsor non finanzia nulla
    foreign key(ID_Artista) references Artista(ID_Artista) on delete set null  #se elimino una performance al momento lo sponsor non finanzia nessuno

    
);

create table Partecipazione(
    ID_Artista int,
    ID_Performance int,
    primary key(ID_Artista, ID_Performance),

    foreign key(ID_Artista) references Artista(ID_Artista) on delete cascade,  #se elimino un artista, non c'è la sua partecipazione
    foreign key(ID_Performance) references Performance(ID_Performance) on delete cascade  #se elimino una performance non c'è ovviamente alcuna partecipazione
);

INSERT INTO Palco (Denominazione, Località) VALUES 
('Main Stage Arena', 'Milano'),
('Teatro Smeraldo', 'Roma'),
('Green Garden', 'Firenze');

INSERT INTO Performance (ID_Palco, TitoloPerformance, DataPerformance) VALUES 
(1, 'Rock Night 2024', '2024-06-15'),
(2, 'Gran Galà della Lirica', '2024-07-20'),
(1, 'Pop Star Tour', '2024-06-16'),
(3, 'Jazz Under the Stars', '2024-08-05');

INSERT INTO Staff (Nome, Cognome, DataNascita, CodiceFiscale, ID_Palco, Mansione) VALUES 
('Marco', 'Rossi', '1985-03-12', 'RSSMRC85C12H501Z', 1, 'Fonico'),
('Luigi', 'Verdi', '1990-11-25', 'VRDLGU90S25F205A', 1, 'Elettricista'),
('Elena', 'Bianchi', '1988-06-05', 'BNCLNE88H45L219X', 2, 'Direttore di Scena');

INSERT INTO Artista (Nome, Cognome, Identificativo, DataNascita, CodiceFiscale, TipoArtista) VALUES 
('Mario', 'Biondi', 'Mario Biondi', '1971-01-28', 'BNDMRA71A28G273U', 'Singolo'),
(NULL, NULL, 'The Rockers', '2010-05-20', 'TRCKRS10E20X123P', 'Band'),
('Simona', 'Molinari', 'Simona Molinari', '1983-02-23', 'MLNSMN83B63G273V', 'Singolo');

-- Associazioni Performance - Artisti
INSERT INTO Partecipazione (ID_Artista, ID_Performance) VALUES (1, 4), (2, 1), (3, 4);

INSERT INTO Sponsor (Nome) VALUES ('Coca-Cola'), ('Red Bull'), ('Yamaha');

INSERT INTO Sponsorizzazione (ID_Sponsor, ID_Performance, ID_Artista) VALUES 
(1, 1, 2), -- Coca-Cola sponsorizza "Rock Night" e "The Rockers"
(2, 3, NULL), -- Red Bull sponsorizza solo la Performance Pop
(3, NULL, 1); -- Yamaha sponsorizza l'artista Mario Biondi

INSERT INTO Spettatore (Nome, Cognome, DataNascita, CodiceFiscale) VALUES 
('Giulia', 'Neri', '1995-10-15', 'NREGUA95R55H501F'),
('Luca', 'Sanna', '1982-12-04', 'SNNLCU82T04B354C'),
('Marta', 'Fogli', '2001-04-18', 'FGLMRT01D58L123D');

INSERT INTO Pagamento (Importo, Stato) VALUES 
(45.50, 'Completato'),
(120.00, 'Completato'),
(30.00, 'Autorizzato');

INSERT INTO Ordine (ID_Pagamento, ID_Spettatore, DataOrdine, TotaleOrdine) VALUES 
(1, 1, '2024-05-10', 45.50),
(2, 2, '2024-05-15', 120.00),
(3, 3, '2024-05-20', 30.00);

INSERT INTO Biglietto (ID_Performance, ID_Ordine, Prezzo, Posto) VALUES 
(1, 1, 45.50, 12),
(2, 2, 60.00, 101),
(2, 2, 60.00, 102),
(4, 3, 30.00, 5);




#QUERY 1
select ART.Nome as NomeArtista , ART.Cognome as CognomeArtista, ART.Identificativo, count(ART.ID_Artista) as NumeroPartecipazioni
from Artista ART
inner join partecipazione PART on PART.ID_Artista = ART.ID_Artista
group by ART.ID_Artista

#QUERY 2
select PERF.DataPerformance as Giorno, SUM(B.Prezzo) as IncassoTotale
from Performance PERF
inner join Biglietto B ON B.ID_Performance = PERF.ID_Performance 
inner join Ordine O on O.ID_Ordine = B.ID_Ordine 
inner join Pagamento PAG on PAG.ID_Pagamento = O.ID_Pagamento
where PAG.Stato = 'Completato'
group by PERF.DataPerformance
order by PERF.DataPerformance desc

#QUERY 3
select ART.Nome as NomeArtista , ART.Cognome as CognomeArtista, ART.Identificativo, count(distinct PERF.ID_Palco) as NumeroPalchi
from Artista ART
inner join Partecipazione PART on PART.ID_Artista = ART.ID_Artista 
inner join Performance PERF on PERF.ID_Performance = PART.ID_Performance
inner join Palco PAL on PAL.ID_Palco = PERF.ID_Palco
group by ART.ID_Artista
having NumeroPalchi > 1;

#QUERY 4
Mostrare il palco con il maggior numero di spettatori totali./ 

SELECT 
    pa.Denominazione,
    COUNT(b.ID_Biglietto) AS TotaleSpettatori
FROM Palco pa
JOIN Performance p ON pa.ID_Palco = p.ID_Palco
JOIN Biglietto b ON p.ID_Performance = b.ID_Performance
GROUP BY pa.ID_Palco
ORDER BY TotaleSpettatori DESC
LIMIT 1; 

#QUERY 5
Mostrare l’artista che ha generato il maggior incasso in biglietti. 
(richiede join + aggregazioni)/ 

SELECT 
    COALESCE(CONCAT(a.Nome, ' ', a.Cognome), a.Identificativo) AS Artista,
    SUM(b.Prezzo) AS IncassoTotale
FROM Artista a
JOIN Partecipazione pa ON a.ID_Artista = pa.ID_Artista
JOIN Biglietto b ON pa.ID_Performance = b.ID_Performance
GROUP BY a.ID_Artista
ORDER BY IncassoTotale DESC
LIMIT 1; 

#QUERY 6
Mostrare le coppie di artisti che hanno collaborato almeno 2 volte. 
(richiede relazione N–M + grouping)/ 

SELECT 
    pa1.ID_Artista AS Artista1,
    pa2.ID_Artista AS Artista2,
    COUNT() AS NumeroCollaborazioni
FROM Partecipazione pa1
JOIN Partecipazione pa2 
    ON pa1.ID_Performance = pa2.ID_Performance
    AND pa1.ID_Artista < pa2.ID_Artista
GROUP BY pa1.ID_Artista, pa2.ID_Artista
HAVING COUNT() >= 2;

-- QUERY 7
-- Mostrare gli sponsor che hanno sponsorizzato performance in almeno 3 giorni diversi.
SELECT s.id_sponsor, s.nome FROM sponsor s
JOIN sponsorizzazione sp ON s.ID_Sponsor = sp.ID_sponsor JOIN performance p ON p.ID_performance = sp.ID_performance
GROUP BY s.id_sponsor, s.nome
HAVING COUNT(p.DataPerformance) >= 3;

-- QUERY 8
-- Mostrare per ogni giorno il palco con l’incasso più alto.
WITH IncassoPalco AS
(SELECT dataperformance, denominazione, SUM(prezzo) AS incasso_giornaliero FROM palco p
JOIN performance pe ON p.id_palco = pe.id_palco JOIN biglietto b ON pe.id_performance = b.id_performance
GROUP BY dataperformance, denominazione)

SELECT * FROM
IncassoPalco ip1
WHERE incasso_giornaliero = (SELECT MAX(incasso_giornaliero) FROM IncassoPalco ip2 WHERE ip1.dataperformance = ip2.dataperformance);

