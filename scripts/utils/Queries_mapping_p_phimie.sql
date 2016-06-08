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

-----------------------------
Measurement (6)
-----------------------------

SELECT
	dt.code AS dty_code ,
    var.code AS variable_code,
	public.chimiesynthesisvalue.id AS value_id,
	public.chimiesynthesisvalue.valuefloat AS value,	
FROM
	public.datatype dt
	INNER JOIN public.datatypevariableuniteglacpe dtvu
	 ON dt.id = dtvu.dty_id
	INNER JOIN public.variable_glacpe_varg var
	 ON dtvu.var_id = var.id
	INNER JOIN public.chimiesynthesisvalue
	 ON var.nom = public.chimiesynthesisvalue.variable
WHERE
	dt.id = 11
	and var.nom = 'Azote Ammoniacal'
