# PNRGOV-XML-Parser

## Opis

Ten projekt implementuje parser do przetwarzania danych PNRGOV XML (Passenger Name Record). Dane PNR zawierają informacje o pasażerach linii lotniczych, takie jak imię, nazwisko, trasa podróży, numer lotu i inne szczegóły. Parser ma za zadanie wyodrębnić kluczowe informacje i przedstawić je w czytelnej formie.

## Wymagania

- Parser powinien obsługiwać format PNRGOV XML.
- Powinien wydobywać informacje o pasażerach oraz ich lotach.
- Wynik powinien zawierać:
  - **Dane pasażerów:**
    - Nazwisko (**Surname**)
    - Imię (**GivenName**)
  - **Dane lotów:**
    - Data i godzina odlotu (**DepartureDateTime**)
    - Lotnisko odlotu (**DepartureAirport**)
    - Data i godzina przylotu (**ArrivalDateTime**)
    - Lotnisko przylotu (**ArrivalAirport**)
    - Linia lotnicza (**MarketingAirline**)
    - Nr lotu (**FlightNumber**)

## Checklista implementacji

- [x] Wczytanie i analiza pliku PNRGOV XML
- [x] Parsowanie danych pasażerów (Nazwisko, Imię)
- [x] Parsowanie danych lotów (daty, lotniska, linie lotnicze, nr lotu)
- [x] Obsługa błędów w strukturze pliku
- [x] Testowanie na przykładowych danych
- [x] Formatowanie wyników w czytelnej postaci

## Źródła

- Więcej informacji o formacie PNRGOV XML: [IATA PNRGOV XML Guide](https://www.iata.org/contentassets/18a5fdb2dc144d619a8c10dc1472ae80/pnrgov20xml20implementation20guide2016_1.pdf)
- Kontekst prawny i zastosowanie: [Rada UE - PNR](https://www.consilium.europa.eu/pl/policies/fight-against-terrorism/passenger-name-record/)
