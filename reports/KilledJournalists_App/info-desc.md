

## Análisis de correspondencias.

----

#### Relación de impunidad con otras variables:

**Fuente:** Censo de periodístas asesinados de enero de 1992 a mayo de 2017 del 
[**Comité para la Protección de los Periodistas**](https://cpj.org/).


**Objetivo:** Encontrar la relación de impunidad con otras variables descriptivas:

  - `source of fire`
  - `coverages`
  - `jobs`
  - `mediums`
  - `gender`
  - `type of death`
  - `tortured`
  - `captive`
  - `threatened`
  - `country killed`
  - `region`


---

#### Definiciones:


- El CPJ define a los periodistas como personas que cubren noticias o hacen comentarios sobre asuntos públicos a través de cualquier medio de comunicación, incluidos los impresos, las fotografías, la radio, la televisión y en línea. Toman casos que involucran a periodistas, freelancers, intermediarios, bloggers y periodistas ciudadanos.

- El CPJ clasifica la **impunidad** en cuatro categorías: 
      - Impunidad total (`Complete Impunity`)
      - Impunidad parcial (`Partial Impunity`)
      - Justicia (`Full Justice`)
      - Desconocido (`Unknown`)

- El análisis únicamente considera los casos que tienen **motivo confirmado** de asesinato relacionado al trabajo del peridísta. En el panel de **Tendencias** se puede observar el número de casos en el tiempo por motivo para diferentes países. 

- Los datos del año 2017 de motivo no confirmado no están disponibles, por lo tanto, imputó el valor con un promedio movil simple usando el paquete [**imputeTS**](https://cran.r-project.org/web/packages/imputeTS/index.html).  

- El análisis de correspondencias se realiza con la función `CA()`del paquete [**FactoMineR**](https://cran.r-project.org/web/packages/FactoMineR/index.html).

- Mayor información de la descripción de los datos y variables
se puede consultar en [**data methodology**](https://cpj.org/data/methodology/).


---

#### Código:

Código disponible [ca_cpj_journalistskilled](https://github.com/Songeo/ca_cpj_journalistskilled)

Creado por [Songeo](https://github.com/Songeo).

