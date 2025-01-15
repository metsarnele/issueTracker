-- Tabel projektide andmete hoidmiseks.
CREATE TABLE Projects (
    project_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne projekti ID. Kasutame INT UNSIGNED, kuna ID väärtused on alati positiivsed. AUTO_INCREMENT võimaldab ID-d automaatselt genereerida.',
    project_name VARCHAR(100) NOT NULL COMMENT 'Projekti nimi. VARCHAR(100) on piisav, et salvestada enamiku projektide pealkirju.',
    description TEXT DEFAULT NULL COMMENT 'Projekti kirjeldus. TEXT valiti, kuna see võimaldab salvestada pikemaid kirjeldusi ilma kindla pikkuse piiranguta.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Projekti loomise kuupäev ja kellaaeg. TIMESTAMP tagab ajavööndi tugi ning automaatse salvestamise.',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimane muutmise kuupäev ja kellaaeg. TIMESTAMP koos ON UPDATE tagab automaatse ajatempli uuendamise igal muutmisel.'
) ENGINE=InnoDB COMMENT='Tabel projektide andmete hoidmiseks.';

-- Näidisandmed projektidele.
INSERT INTO Projects (project_name, description)
VALUES 
('Issue Tracker', 'Rakendus ülesannete jälgimiseks ja haldamiseks.'),
('CRM Tool', 'Klientide ja müügihalduse rakendus.');

-- Tabel kasutajalugude andmete hoidmiseks.
CREATE TABLE UserStories (
    story_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne kasutajaloo ID. Kasutame INT UNSIGNED, kuna ID väärtused on alati positiivsed. AUTO_INCREMENT tagab ID automaatse genereerimise.',
    project_id INT UNSIGNED NOT NULL COMMENT 'Viide projektile, mille osa see kasutajalugu on. INT UNSIGNED sobib seostatud positiivsete ID-de hoidmiseks.',
    title VARCHAR(255) NOT NULL COMMENT 'Kasutajaloo pealkiri. VARCHAR(255) võimaldab mahutada nii lühikesi kui ka pikemaid pealkirju.',
    description TEXT NOT NULL COMMENT 'Kasutajaloo üksikasjalik kirjeldus. TEXT sobib muutuvate ja pika sisu hoidmiseks.',
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium' COMMENT 'Kasutajaloo prioriteet. ENUM piirab väärtused kindlate valikute vahel, vältides vigaseid andmeid.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Kasutajaloo loomise kuupäev ja kellaaeg. TIMESTAMP sobib automaatse ajatempli loomiseks.',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimane muudatuse kuupäev ja kellaaeg. TIMESTAMP võimaldab automaatset ajatempli värskendamist.',
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Tabel kasutajalugude haldamiseks.';

-- Näidisandmed kasutajalugudele.
INSERT INTO UserStories (project_id, title, description, priority)
VALUES 
(1, 'Kasutaja registreerimine', 'Kasutajana tahan registreeruda, et pääseda ligi rakenduse funktsioonidele.', 'high'),
(1, 'Kasutaja sisselogimine', 'Kasutajana tahan sisselogida, et näha isikustatud sisu.', 'critical'),
(2, 'Andmete eksport Excelisse', 'Kasutajana tahan eksportida andmeid Excelisse, et neid analüüsida.', 'medium');

-- Tabel kriteeriumide andmete hoidmiseks.
CREATE TABLE Criteria (
    criterion_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne kriteeriumi ID. Kasutame INT UNSIGNED positiivsete väärtuste jaoks. AUTO_INCREMENT võimaldab ID automaatset genereerimist.',
    story_id INT UNSIGNED NOT NULL COMMENT 'Viide kasutajaloole, mille osa see kriteerium on. INT UNSIGNED võimaldab viidata seotud positiivsetele ID-dele.',
    criterion_name VARCHAR(255) NOT NULL COMMENT 'Kriteeriumi nimi. VARCHAR(255) võimaldab piisavalt ruumi nii lühikeste kui ka pikemate nimede salvestamiseks.',
    status ENUM('todo', 'in_progress', 'done', 'blocked') DEFAULT 'todo' COMMENT 'Kriteeriumi staatus. ENUM tagab, et olekud on piiratud kindlate väärtustega, mis väldib vigaseid andmeid.',
    due_date TIMESTAMP DEFAULT NULL COMMENT 'Kriteeriumi tähtaeg. TIMESTAMP salvestab nii kuupäeva kui ka kellaaja. NULL võimaldab tähtaega mitte määrata.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Kriteeriumi loomise kuupäev ja kellaaeg. TIMESTAMP on efektiivne ja automaatne.',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimane muudatuse kuupäev ja kellaaeg. TIMESTAMP uuendatakse automaatselt igal muudatusel.',
    FOREIGN KEY (story_id) REFERENCES UserStories(story_id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Tabel kriteeriumide haldamiseks.';

-- Näidisandmed kriteeriumidele.
INSERT INTO Criteria (story_id, criterion_name, status, due_date)
VALUES 
(1, 'Registreerimisvormi loomine', 'in_progress', '2025-02-01 10:00:00'),
(1, 'E-posti valideerimine', 'todo', '2025-02-05 12:00:00'),
(2, 'Sisselogimise API loomine', 'blocked', '2025-01-25 15:00:00'),
(3, 'Exceli eksportimise backend-funktsioon', 'done', NULL);

-- Tabel kommentaaride andmete hoidmiseks.
CREATE TABLE Comments (
    comment_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne kommentaari ID. INT UNSIGNED võimaldab positiivseid väärtusi ja AUTO_INCREMENT genereerib automaatselt uue ID.',
    criterion_id INT UNSIGNED DEFAULT NULL COMMENT 'Viide kriteeriumile, mille kohta kommentaar lisati. INT UNSIGNED on valitud seotud positiivsete väärtuste hoidmiseks.',
    story_id INT UNSIGNED DEFAULT NULL COMMENT 'Viide kasutajaloole, mille kohta kommentaar lisati. NULL tähendab, et kommentaar on seotud ainult kriteeriumiga.',
    user_id INT UNSIGNED NOT NULL COMMENT 'Viide kasutajale, kes kommentaari lisas. INT UNSIGNED tagab positiivsete ID-de kasutamise.',
    comment_text TEXT NOT NULL COMMENT 'Kommentaari sisu. TEXT sobib pika ja muutliku sisuga väljade jaoks.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Kommentaari loomise kuupäev ja kellaaeg. TIMESTAMP tagab automaatse salvestamise.',
    FOREIGN KEY (criterion_id) REFERENCES Criteria(criterion_id) ON DELETE SET NULL,
    FOREIGN KEY (story_id) REFERENCES UserStories(story_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Tabel kommentaaride haldamiseks.';

-- Näidisandmed kommentaaridele.
INSERT INTO Comments (criterion_id, story_id, user_id, comment_text)
VALUES 
(1, NULL, 1, 'Palun lisada rohkem valideerimisreegleid.'),
(NULL, 2, 2, 'Kas on plaanis sisselogimise kaksik-autentimine?'),
(3, NULL, 1, 'Exceli eksportimine töötab ootuspäraselt.');

-- Tabel siltide andmete hoidmiseks.
CREATE TABLE Labels (
    label_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne sildi ID. INT UNSIGNED valiti positiivsete väärtuste jaoks ja AUTO_INCREMENT tagab automaatse ID loomise.',
    story_id INT UNSIGNED DEFAULT NULL COMMENT 'Viide kasutajaloole, millele silt kuulub. INT UNSIGNED on valitud seotud positiivsete väärtuste jaoks.',
    criterion_id INT UNSIGNED DEFAULT NULL COMMENT 'Viide kriteeriumile, millele silt kuulub. NULL võimaldab silt olla seotud ainult kasutajalooga.',
    label_name VARCHAR(50) NOT NULL COMMENT 'Sildi nimi. VARCHAR(50) on piisav lühikeste ja selgete siltide salvestamiseks.',
    color_code VARCHAR(7) DEFAULT '#FFFFFF' COMMENT 'Sildi värvikood heksavormingus (nt #FFFFFF valge). VARCHAR(7) võimaldab salvestada standardseid värvikoodide pikkusi.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Sildi loomise kuupäev ja kellaaeg. TIMESTAMP on efektiivne ajatempli salvestamiseks.',
    FOREIGN KEY (story_id) REFERENCES UserStories(story_id) ON DELETE SET NULL,
    FOREIGN KEY (criterion_id) REFERENCES Criteria(criterion_id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Tabel siltide haldamiseks.';

-- Näidisandmed siltidele.
INSERT INTO Labels (story_id, criterion_id, label_name, color_code)
VALUES 
(1, NULL, 'High Priority', '#FF0000'),
(NULL, 2, 'Frontend', '#00FF00'),
(3, NULL, 'Backend', '#0000FF');
