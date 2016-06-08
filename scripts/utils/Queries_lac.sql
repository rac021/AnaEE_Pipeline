SELECT
	chimiesynthesisvalue.site AS site_code,
	site_glacpe_sit.nom AS site_name,
	datatype.code AS datatype_code,
	datatype.name AS datatype_name,
	variable_glacpe_varg.code AS variable_code,
	chimiesynthesisvalue.variable AS variable_name,
	unite.code AS unite_id,
	unite.code AS unite_code,
	unite.nom AS unite_name,
	to_char( chimiesynthesisvalue.date , 'YYYY' : : text ) AS year,
	count( * ) AS nb_data
FROM
	public.datatype
	INNER JOIN public.datatypevariableuniteglacpe
	 ON public.datatype.id = public.datatypevariableuniteglacpe.dty_id
	INNER JOIN public.unite
	 ON public.datatypevariableuniteglacpe.uni_id = public.unite.id
	INNER JOIN public.variable_glacpe_varg
	 ON public.datatypevariableuniteglacpe.var_id = public.variable_glacpe_varg.id
	INNER JOIN public.chimiesynthesisvalue
	 ON public.variable_glacpe_varg.nom = public.chimiesynthesisvalue.variable
	INNER JOIN public.site_glacpe_sit
	 ON public.chimiesynthesisvalue.site = public.site_glacpe_sit.code
WHERE
	datatype.id = 11
GROUP BY
	chimiesynthesisvalue.site,
	site_glacpe_sit.nom,
	datatype.code,
	datatype.name,
	variable_glacpe_varg.code,
	chimiesynthesisvalue.variable,
	unite.code,
	unite.nom,
	to_char(chimiesynthesisvalue.date,'YYYY'::text)
