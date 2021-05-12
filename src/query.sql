-- R1. Prénom et nom des malades affiliés à la mutuelle « MAAF ».
SELECT prenom, nom 
FROM malade 
WHERE mutuelle = 'MAAF'; 

-- R2. Prénom et nom des infirmier(ères) travaillant pendant la rotation de nuit.
SELECT E.prenom, E.nom 
FROM employe E, infirmier I 
WHERE E.numero = I.numero
AND I.rotation = 'NUIT'
ORDER BY E.nom ASC;

-- R3. Donner pour chaque service, son nom, son bâtiment,
-- ainsi que les prénom, nom et spécialité de son directeur.
SELECT S.nom, S.batiment, E.prenom, E.nom, D.specialite
FROM service S, employe E, docteur D
WHERE D.numero = S.directeur
AND E.numero = D.numero
ORDER BY E.nom ASC;

-- R4. Donner pour chaque lit occupé du bâtiment « B » de l’hôpital
-- occupé par un malade affilié à une mutuelle dont le nom commence par « MN... »,
-- le numéro du lit, le numéro de la chambre, le nom du service ainsi que le prénom,
-- le nom et la mutuelle du malade l’occupant.
SELECT H.no_chambre, H.lit, S.nom, M.prenom, M.nom, M.mutuelle
FROM hospitalisation H, service S, malade M
WHERE S.batiment = 'B'
AND M.mutuelle LIKE 'MN%'
AND H.no_malade = M.numero
AND S.code = H.code_service
ORDER BY M.nom ASC;

-- R5. Quelle est la moyenne des salaires des infirmiers(ères) par service ?
SELECT I.code_service, ROUND(AVG(I.salaire), 2) AS moyenne_des_salaires
FROM infirmier I
GROUP BY I.code_service;

-- R6. Pour chaque service du bâtiment « A » de l’hôpital,
-- quel est le nombre moyen de lits par chambre ?
SELECT C.code_service, ROUND(AVG(C.nb_lits), 1) AS nb_moyen_de_lits
FROM chambre C, service S
WHERE S.batiment = 'A'
AND S.code = C.code_service
GROUP BY C.code_service;

-- R7. Pour chaque malade soigné par plus de 3 médecins donner le nombre total de ses médecins
-- ainsi que le nombre correspondant de spécialités médicales concernées.
SELECT M.nom, M.prenom, COUNT(*) AS nb_soignant, COUNT(DISTINCT D.specialite) AS nb_specialite
FROM soigne S, malade M, docteur D
WHERE M.numero = S.no_malade
AND S.no_docteur = D.numero
GROUP BY M.nom, M.prenom
HAVING COUNT(*) > 3;

-- R8. Pour chaque service quel est le rapport entre le nombre d’infirmier(ères)
-- affecté(es) au service et le nombre de malades hospitalisés dans le service ?
SELECT S.nom, I.nb_infirmiers/P.nb_patients AS rapport_i_sur_m
FROM (SELECT code_service, COUNT(*) AS nb_patients
        FROM hospitalisation
        GROUP BY code_service) P,
     (SELECT code_service, COUNT(*) AS nb_infirmiers
        FROM infirmier
        GROUP BY code_service) I, service S
WHERE P.code_service = I.code_service
AND S.code = P.code_service;

-- R9. Prénom et nom des docteurs ayant au moins un malade hospitalisé.
SELECT DISTINCT E.nom, E.prenom
FROM soigne S, employe E, hospitalisation H 
WHERE E.numero = S.no_docteur
AND S.no_malade = H.no_malade


-- R10 Prénom et nom des docteurs n’ayant aucun malade hospitalisé.
SELECT E.prenom, E.nom
FROM employe E, docteur D
WHERE D.numero = E.numero
	AND D.numero NOT IN (SELECT S.no_docteur
                         FROM hospitalisation H, soigne s
                         WHERE S.no_malade = H.no_malade)
ORDER BY E.nom

-- R11. Pour chaque docteur, retrouver le nombre de ses malades hospitalisés, y compris ceux dont le nombre est 0.
SELECT E.prenom, E.nom, COUNT(H.no_malade) AS nombre_hospi
FROM employe E, soigne S LEFT OUTER JOIN hospitalisation H ON S.no_malade = H.no_malade
WHERE E.numero = S.no_docteur
GROUP BY E.prenom, E.nom
ORDER BY E.nom
/*******OU********/
SELECT E.prenom, E.nom, COUNT(*)
FROM employe E, soigne S, hospitalisation H
WHERE E.numero = S.no_docteur AND S.no_malade = H.no_malade
GROUP BY E.nom, E.prenom
UNION
SELECT DISTINCT E.prenom, E.nom, 0
FROM employe E, docteur D
WHERE D.numero = E.numero AND E.numero NOT IN (SELECT S.no_docteur
                                                                FROM soigne S, hospitalisation H
                                                                WHERE S.no_malade = H.no_malade)


-- R12. Bâtiment et numéro des chambres occupées par au moins un malade (hospitalisé).
SELECT distinct S.batiment, C.no_chambre
FROM service S, chambre C, hospitalisation H
WHERE S.code = C.code_service AND C.code_service = H.code_service AND C.no_chambre = H.no_chambre
ORDER BY S.batiment, C.no_chambre DESC

-- R13. Bâtiment et numéro des chambres vides (aucun malade n’y est hospitalisé).
  SELECT distinct S.batiment, C.no_chambre
FROM service S, hospitalisation H, chambre C
WHERE C.code_service = S.code AND (C.code_service, C.no_chambre) NOT IN (SELECT H.code_service, H.no_chambre
                                                                         FROM hospitalisation H)
        

-- R14. Pour chaque chambre, donner le bâtiment, le numéro, le nombre total de lits et le nombre des lits occupés par les malades qui y sont hospitalisés, y compris quand le nombre est 0.


-- R15. Prénom et nom des docteurs ayant un malade hospitalisé dans chaque service.


-- R16. Prénom et nom des docteurs ayant un malade hospitalisé dans chaque chambre dont l’infirmier surveillant est « Roddick ».


-- R17. Prénom et nom des malades soignés par le directeur du service dans lequel ils sont hospitalisés.


-- R18. Quelles sont les chambres qui ont des lits disponibles dans le service de cardiologie (dont le nom est « Cardiologie ») ?