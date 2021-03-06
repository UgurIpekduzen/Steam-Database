USE GAMES_SALES_PLATFORM
GO

--1. SORGU YARIM
--SELECT  O.ADI,COUNT(TUR) AS TOPLAM ,
--CASE WHEN TUR=1 THEN  'OLUMLU' ELSE 'OLUMSUZ' END AS TUR 
--FROM YORUMYAPAR Y INNER JOIN OYUN O ON Y.OYUN_ID=O.OYUN_ID
--WHERE O.OYUN_ID IN (
--SELECT O.OYUN_ID
--FROM ODULLER D INNER JOIN OYUN O ON D.OYUN_ID=O.OYUN_ID
--GROUP BY O.OYUN_ID
--HAVING COUNT(O.ADI)>1)
--GROUP BY O.ADI,TUR
--ORDER BY O.ADI

--2.SORGU: K�t�phanesinde hi� futbol kategorisinde oyun olmayan kullan�c�lar�n en �ok oyuna sahip olduklar� 3 kategori ismi
SELECT TOP 3 TUR,COUNT(TUR) AS SAYI
FROM ANAHTAR A 
INNER JOIN ICERIR I ON A.OYUN_ID = I.OYUN_ID 
INNER JOIN KATEGORILER K ON I.KATEGORI_ID = K.KATEGORI_ID
WHERE 
KULLANICI_ID IN(SELECT KULLANICI_ID
FROM ANAHTAR
EXCEPT
SELECT KULLANICI_ID
FROM ANAHTAR A 
INNER JOIN ICERIR I ON A.OYUN_ID = I.OYUN_ID 
INNER JOIN KATEGORILER K ON I.KATEGORI_ID = K.KATEGORI_ID
WHERE K.TUR='FUTBOL')
GROUP BY TUR
ORDER BY SAYI DESC

--IKIDEN FAZLA BA�ARISI OLAN KULLANICILARIN SAH�P OLDU�U OYUNLAR
SELECT K.ADI AS KULLANICI_ADI,O.ADI AS OYUN_ADI
FROM OYUN O INNER JOIN ANAHTAR A ON O.OYUN_ID=A.OYUN_ID
INNER JOIN KULLANICI K ON A.KULLANICI_ID=K.KULLANICI_ID
WHERE K.KULLANICI_ID IN(
SELECT K.KULLANICI_ID
FROM KAZANIR K INNER JOIN KULLANICI U ON K.KULLANICI_ID=U.KULLANICI_ID
GROUP BY K.KULLANICI_ID
HAVING COUNT(K.KULLANICI_ID)>2)
ORDER BY KULLANICI_ADI


--BUNDLE'A SAHIP OLMAYAN EN Y�KSEK F�YATA SAH�P 3 OYUN
SELECT TOP 3 O.ADI,A.FIYAT
FROM OYUN O INNER JOIN ANAHTAR A ON O.OYUN_ID=A.OYUN_ID
WHERE O.OYUN_ID IN (
SELECT OYUN_ID
FROM OYUN 
WHERE BUNDLE_ID IS NULL)
GROUP BY O.ADI,A.FIYAT
ORDER BY A.FIYAT DESC

--YAYIMCI 1'�N YAYIMLADI�I OYUN BULUNMAYAN KULLANICILARIN TOPLAM HARCAMA MIKTARLARI
SELECT K.ADI AS KULLANICI_ADI,SUM(TUTAR) AS TOPLAM_HARCAMA
FROM FATURA F INNER JOIN KULLANICI K ON F.KULLANICI_ID=K.KULLANICI_ID
WHERE K.KULLANICI_ID IN(
SELECT KULLANICI_ID
FROM KULLANICI
EXCEPT
SELECT DISTINCT K.KULLANICI_ID
FROM YAYIMCI Y INNER JOIN OYUN O ON Y.YAYIMCI_ID=O.YAYIMCI_ID
INNER JOIN ANAHTAR A ON A.OYUN_ID=O.OYUN_ID 
INNER JOIN KULLANICI K ON A.KULLANICI_ID=K.KULLANICI_ID
WHERE Y.ADI='YAYIMCI 1')
GROUP BY K.ADI





