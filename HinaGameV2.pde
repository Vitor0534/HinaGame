/*antações do desenvolvimento:

1) 19/03/2021: até o momento foram implementadas os seguintes pontos
________________* Sprite: é uma classe que pode ser usada para qualquer sprite no jogo, e especifcamente recebe um atributo
__________________________de velocidade, para dizer o passe que a goda deve percorrer na tela. o sprite tb tem atributos gericos como:
__________________________________* pontos xy e dimensões;
________________* Movimento (classe drop): é uma classe que controla todo movimento a cerca das gotas, a classe contem alguns método e atributos tais como:
_____________________________* Randon_drop(): que cria um vetor aleatório de gotas, para se mover na tela;
_____________________________* Move_Drops(): movimenta as gotas pela tela na direção y com base no atributo speed de cada drop;
_____________________________* colision(Sprite): verifica a colisão da gota com a Hina, verificando a sobreposição de áreas;




*/

sprite hina;
drag drag1;
Drops drops;
int MinimumSpeed,MaximumSpeed;

PImage splash;
//font de texto
PFont font;

void setup()
{
  size(500,800);
  PImage img = loadImage("sprites/Hina.png");
  img.resize(200,300);
  hina=new sprite(img,500/2 - img.width/2,800-img.height, 200,300,"H");
  drag1= new drag(hina);
  //drops = new Drops(loadImage("sprites/drop-37739.png"),30,50);
  drops = new Drops(loadImage("sprites/drop.png"),30,50);
  splash = loadImage("sprites/splash_2.png");
  splash.resize(100,70);
  font = createFont("Arial",30);
  
  MinimumSpeed = 2;
  MaximumSpeed = 10;
}

class sprite
{
  PImage sprite;
  int x;
  int y;
  int largura;
  int altura;
  int speed; //velocidade da gota, so é usada para gotas
  String ID;
  sprite(PImage sprite, int x, int y, int largura, int altura, String ID)
  {
  this.sprite = sprite;
  this.x=x;
  this.y=y;
  this.largura= largura;
  this.altura=altura;
  sprite.resize(this.largura,this.altura);
  this.ID = ID;
  }
  sprite(PImage sprite, int x, int y, int largura, int altura, int speed, String ID)
  {
  this.sprite = sprite;
  this.x=x;
  this.y=y;
  this.largura= largura;
  this.altura=altura;
  this.speed = speed;
  this.ID = ID;
  }
  
  void spriteImg(PImage sprite)
  {
   this.sprite=sprite; 
  }
  PImage spriteImg()
  {
   return sprite; 
  }
  int x()
  {
    return this.x;
  }
  void x(int x)
  {
    this.x=x;
  }
  
  int y()
  {
   return this.y; 
  }
  void y(int y)
  {
   this.y=y; 
  }
  int largura()
  {
   return this.largura; 
  }
  void largura(int l)
  {
   this.largura=l; 
  }
  int altura()
  {
   return altura; 
  }
  void altura(int a)
  {
   this.altura=a; 
  }
  
  void speed(int speed)
  {
   this.speed=speed; 
  }
  int speed()
  {
   return speed; 
  }
  
  boolean isOver(int mouse_x, int mouse_y)
  {
    if((mouse_x >= this.x && mouse_x<= (this.x + this.largura)) 
        && (mouse_y >=this.y && mouse_y<= (this.y+this.altura)))
     return true;
     
     return false;
  }
  
  void show()
  {
    image(this.sprite,this.x,this.y,this.largura,this.altura);
  }
  
}



void msg_carregamento(String MSG, int x, int y, PFont fonte, int tam_font,color c)
{
  textFont(fonte);
  textSize(tam_font);
  fill(c);
  text(MSG,x,y);
}

class drag
{
  sprite hina;
  boolean selected;             //variáveis de controle da classe, indica se existe um obj selecionado
  boolean condicao_arrastar_ed;  //indica se é permitido arrastar aquele obijeto
  
  drag(sprite hina)
  {
    this.hina=hina;
    this.selected=false;
    this.condicao_arrastar_ed=false;
  }
  
  
  boolean get_selected()
  {
    return this.selected;
  }
  boolean get_condicao_arrastar_ed()
  {
    return this.condicao_arrastar_ed;
  }
  void set_condicao_arrastar_ed(boolean condicao_arrastar_ed)
  {
    this.condicao_arrastar_ed=condicao_arrastar_ed;
  }
  
  
  
  void dragSprite(int Mx, int My)
  {

      if (mousePressed && this.hina.isOver(Mx, My))
      {
        int pos = Mx - hina.largura()/2;
        this.hina.x(pos);
        println("draging obj");
      } 
  }
  
}


class Drops
{
  int u;
  PImage drop;
  int largura;
  int altura;
  ArrayList<sprite> DropsN;
  
  Drops(PImage drop, int largura, int altura)
  {
    this.DropsN = new ArrayList<sprite> ();
    this.drop = drop;
    this.largura = largura;
    this.altura=altura;
  }
  
  void Random_Drops()
  {
    this.u = round(random(5,8));
    for(int i=0;i<u;i++)
    {
     int speed = round(random(MinimumSpeed,MaximumSpeed));
     sprite aux = new sprite(this.drop.copy(),round(random(0,500)), round(random(-100,10)), this.largura,this.altura, speed,"D");
     DropsN.add(aux);
     println("entrei no drop");
    }
    
  }
  
  
  //metodo que move as gotas pela tela
  void Move_Drops()
  {
    
    for(int i=0;i<DropsN.size();i++)
    {
      //int speed =random(1,5);
      DropsN.get(i).y(DropsN.get(i).y+DropsN.get(i).speed());
      DropsN.get(i).show();
    }
    
    //verfica se saiu da tela para gerar novas ou se atingiu a Hina
    for(int i=0;i<DropsN.size();i++)
    {
      //testa para ver o impácto na hina
      if(colision(DropsN.get(i)))
     {
       //remove a gota que atingil rina e faz a animação de splash
        DropsN.get(i).spriteImg(splash);
        DropsN.get(i).largura(100);
        DropsN.get(i).altura(70);
        time=1;
       DropsN.get(i).show();
       DropsN.remove(i);
       
       qtd_Pontos++; //incrementa a quantidade de pontos a cada colisão 
       int speed = round(random(MinimumSpeed,MaximumSpeed));
       sprite aux = new sprite(this.drop.copy(),round(random(0,500)), round(random(-100,10)), this.largura,this.altura,speed,"D");
       DropsN.add(aux);
     }
     else{
      //verifica se saiu da tela
      if(DropsN.get(i).y>height)
      {
       DropsN.remove(i);
       int speed = round(random(MinimumSpeed,MaximumSpeed));
       sprite aux = new sprite(this.drop.copy(),round(random(0,500)), round(random(-100,10)), this.largura,this.altura,speed,"D");
       DropsN.add(aux);
       qtd_Erros++;
      }
     }
    }
    
  }
  
  //função que verifica se ouve colsão da gota com a Hina
  boolean colision(sprite drop)
  {
    //basicamene verifica se a gota está em cima do sprite da hina, para isso é usada a área da gota e da hina
    if( ((drop.x() >= hina.x()) && (drop.x() <= (hina.x()+hina.largura()))) 
         && ( (drop.y() >=hina.y()) && (drop.y()<= (hina.y()+hina.altura))))
    {
      return true;
    }
    return false;
    
  }
  
  
}

int k=0;
int qtd_Pontos=0;
int qtd_Erros=0;
int time=0;
void draw()
{
  //gambiarra para animar o splash, tem que criar uma função de animação específica para isso
  if(time==1) 
  {
    delay(40);
    time=0;
  }
  background(255);
  hina.show();
  drag1.dragSprite(mouseX,mouseY);
  
  if(k==0){
     drops.Random_Drops();
     k=1;
  }
  drops.Move_Drops();
  msg_carregamento("Acertos:" + Integer.toString(qtd_Pontos),10,50, font, 30, color(#4704D8));
  msg_carregamento("Erros:" + Integer.toString(qtd_Erros),10,100, font, 30, color(#4704D8));
 
}
