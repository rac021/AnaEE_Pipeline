-----------------------------
Measurement (2)
-----------------------------

SELECT
var.code AS variable_code
FROM
public.datatype AS dt
INNER JOIN public.datatypevariableuniteglacpe AS dtvu
ON dt.id = dtvu.dty_id
INNER JOIN public.variable_glacpe_varg AS var
ON dtvu.var_id = var.id
WHERE
dt.id = 11  and var.nom='Azote Ammoniacal'

--------------------------------------------------------
