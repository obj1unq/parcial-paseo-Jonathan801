object abrigoDePrendaLiviana{
	var property nivel = 1
}
class Prenda{
	var  talle= null
	var desgaste = 0
	var abrigo=1
	method tallePrenda()=talle.talle()
	method coincideTalle(hijo)=if(self.tallePrenda()==hijo.talleMio()) 8 else 0
	method nivelDesgaste(hijo)
	method nivelComodidad(hijo)=self.coincideTalle(hijo) - self.nivelDesgaste(hijo).min(3)
	method nivelAbrigo()=abrigo
	method nivelCalidad(hijo)=self.nivelAbrigo() + self.nivelComodidad(hijo)
	method usarPrenda()
	method incrementarDesgaste(valor){desgaste+=valor}

}
class PrendaPar inherits Prenda{
	var property prendaIzq=null
	var property prendaDer=null
	method izquierdo()=prendaIzq
	method derecho()=prendaDer
	override method nivelDesgaste(hijo)=(prendaIzq.nivelDesgaste(hijo) + prendaDer.nivelDesgaste(hijo))/2
	override method nivelComodidad(hijo)=super(hijo)-if(hijo.edad()<4) 1 else 0
	method cambiarPrenda(prendaParDer){
		prendaDer=prendaParDer
	}
	method condicionParaIntercambiar(prendaPar)=self.tallePrenda()!=prendaPar.tallePrenda()
	method esIntercambiable(prendaPar){
		if(self.condicionParaIntercambiar(prendaPar)){
			self.error("La prenda no es intercambiable") 
		}
    }
	method intercambiarPrenda(prendaPar){
		self.esIntercambiable(prendaPar)
		var prendaDerOriginal=self.derecho()
		self.cambiarPrenda(prendaPar.prendaDer())
		prendaPar.cambiarPrenda(prendaDerOriginal)
	}
	override method nivelAbrigo()=prendaIzq.nivelAbrigo()+prendaDer.nivelAbrigo()
	override method usarPrenda(){
		prendaIzq.usarPrenda()
		prendaDer.usarPrenda()
	}
}
class PrendaParIzq inherits Prenda {
	override method nivelDesgaste(hijo)=desgaste
	override method usarPrenda(){
		self.incrementarDesgaste(0.8)
	}
}
class PrendaParDer inherits Prenda {
	override method nivelDesgaste(hijo)=desgaste
	override method usarPrenda(){
		self.incrementarDesgaste(1.20)
	}
}
class PrendaPesada inherits Prenda{
    override method nivelDesgaste(hijo)=desgaste
	override method usarPrenda(){
		self.incrementarDesgaste(1)
	}
}
class PrendaLiviana inherits PrendaPesada{
	override method nivelComodidad(hijo)=super(hijo) + 2
	override method nivelAbrigo()=abrigoDePrendaLiviana.nivel()
}
class Hijo{
	var talle
	var property edad
	var property prendas=#{}
	method talleMio()=talle.talle()
	method cantPrendasUsadas()=prendas.size()
	method cantPrendasNecesariasParaSalir()=5
	method tienePrendaConAbrigoSuperior()=prendas.any({prenda=>prenda.nivelAbrigo()>=3})
	method prendasRequeridas()=self.cantPrendasUsadas()==self.cantPrendasNecesariasParaSalir() and self.tienePrendaConAbrigoSuperior()
	method prendasDeCalidad()=prendas.sum({prenda=>prenda.nivelCalidad(self)})/self.cantPrendasUsadas()>8
	method puedeSalir()=self.prendasRequeridas() and self.prendasDeCalidad()
	method prendaInfaltable()=prendas.max({prenda=>prenda.nivelCalidad(self)})
	method usarPrendas(){
		prendas.forEach({prenda=>prenda.usarPrenda()})
	}
}
class HijoProblematico inherits Hijo{
	var juguete=null
	override method cantPrendasNecesariasParaSalir()= 4
	
	override method puedeSalir()=juguete.esAptoPara(self) and super()
}
class Familia{
	var ninios=#{}
	method puedeSalirDePaseo()=ninios.all({ninio=>ninio.puedeSalir()})
	method intentarLaSalida(){
		if(!self.puedeSalirDePaseo()){
			self.error("No se pudo salir de paseo")
		}
	}
	method prendasInfaltables()=ninios.map({ninio=>ninio.prendaInfaltable()}).asSet()//Por las dudas el asSet()
	method hijosChiquitos()=ninios.filter({ninio=>ninio.edad()<4})
	method salirDePaseo(){
		self.intentarLaSalida()
		ninios.forEach({ninio=>ninio.usarPrendas()})
	}
}
class Juguete{
	var edadMinima
	var edadMaxima
	method esAptoPara(hijo)=hijo.edad().between(edadMinima,edadMaxima)
}
//Objetos usados para los talles
object xs {
	method talle()="xs"
}

object s {
	method talle()="s"
}
object m {
	method talle()="m"
}
object l{
	method talle()="l"
}
object xl{
	method talle()="xl"
}