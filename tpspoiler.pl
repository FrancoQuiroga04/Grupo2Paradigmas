%PUNTO 1:
%No sé si se pueden usar listas en la parte de series para cada persona, quedaría mucho mejor.
quienMiraQue(juan, himym).
quienMiraQue(juan, got).
quienMiraQue(juan, futurama).
quienMiraQue(nico, starWars).
quienMiraQue(nico, got).
quienMiraQue(maiu, starWars).
quienMiraQue(maiu, onePiece).
quienMiraQue(maiu, got).
quienMiraQue(gaston, got).
%Alf no ve ninguna serie. Por principio de universo cerrado, asumimos que es falso y directamente no modelamos el hecho de que no mire nada.
%Tampoco decimos que nadie ve Mad Men por la misma razón que no formulamos el hecho de que Alf no mira ninguna serie.

quienPlaneaVerQue(juan, hoc).
quienPlaneaVerQue(aye, got).
quienPlaneaVerQue(gaston, himym).

%cuántosEpisodiosTieneTalTemporada (Serie, Temporada, Episodio)
cuantosEpisodiosTieneTalTemporada(got, 10, 2).
cuantosEpisodiosTieneTalTemporada(got, 12, 3).
cuantosEpisodiosTieneTalTemporada(himym, 23, 1).
cuantosEpisodiosTieneTalTemporada(drHouse, 16, 8).
%No sabemos cuántos episodios tiene la segunda temporada de Mad Men, por lo cual tampoco sabemos si contiene alguno, y por principio de universo cerrado no nos interesa consultar si es que los tiene y asumimos que es falso, dejándo la proposición sin modelar.

%PUNTO 2:
%paso(Serie, Temporada, Episodio, Lo que paso)

paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

%PUNTO 3:

%esSpoiler (Serie, Lo que pasó en esa serie).

esSpoiler(starWars, muerte(emperor)).
esSpoiler(starWars, relacion(parentesco, anakin, rey)).
esSpoiler(starWars, relacion(parentesco, vader, luke)).
esSpoiler(futurama, muerte(seymourDiera)).
esSpoiler(himym, relacion(amorosa, swarley, robin)).
esSpoiler(himym, relacion(amorosa, ted, robin)).
esSpoiler(got, relacion(amistad, tyrion, dragon)).


%PUNTO 4:

leSpoileo(Nombre1, Nombre2, Serie):-
quienMiraQue(Nombre2, Serie),
paso(Serie, _, _, Spoiler),
leDijo(Nombre1, Nombre2, Serie, Spoiler).

leSpoileo(Nombre1, Nombre2, Serie):-
quienPlaneaVerQue(Nombre2, Serie),
paso(Serie, _, _, Spoiler),
leDijo(Nombre1, Nombre2, Serie, Spoiler).

%PUNTO 5 NO FUNCA:

televidenteResponsable(Televidente):-
quienMiraQue(Televidente, _), not(leSpoileo(Televidente, _, _)).
