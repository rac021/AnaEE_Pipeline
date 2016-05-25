
PREFIX : <http://www.anaee/fr/soere/ola#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX oboe-core: <http://ecoinformatics.org/oboe/oboe.1.0/oboe-core.owl#>

SELECT ?uri ?unite {
  	?uri a oboe-core:Measurement .
 	?uri oboe-core:hasValue ?unite
}
