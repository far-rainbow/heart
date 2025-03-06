#!/bin/bash
declare LOG="debug.log"
declare tcLtR="\033[01;31m"    # LIGHT RED
declare tcRESET="\033[0m"

function quit(){
  echo -e  $tcRESET >&2
  clear
  tput cnorm
  exit
}

clear
tput civis
echo -e  $tcLtR >&2

trap '' SIGINT
trap 'quit' EXIT ERR

for i in {1..140};do
  read -sn1 -t0.2 && exit
  echo
#  sleep 0.1 
#printf '%*s' $(((COLS-${#copyright})/2))
done | awk -v lin=$LINES -v col=$COLUMNS '
  # formula from https://pikabu.ru/story/idealnoe_serdtse_matematikam_na_zametku_1885710
  # changed by me
  function heartR(w,B){return (1-B+B*rand())*(sin(w)*sqrt(cos(w))/(sin(w)+7/5)-2*sin(w)+2)}
  BEGIN{
  copyright="С ПРАЗДНИКОМ! (c) Tagd 2025"
  copyright=sprintf("%*s", int((col+length(copyright))/2),copyright)
  pi = atan2(0,-1)
  maxx=2.23
  maxy=0.65
  miny=-4
  h_char="·♡♥♥♡· "
  lh=length(h_char)
  for(i=1;i<=lh;i++){H[i-1]=substr(h_char,i,1)}
  scr_len=(lin-1)*col
  scr=sprintf("%*s",scr_len,"")
  scr=scr copyright
  kY=int(lin*0.8)
  kX=int(col*0.4)
  if(kY<kX){R=kY}
  else{R=kX}
  oX=int((col-kX)/2)
  oY=int((lin-kY)/2)

  dw=2*pi/scr_len 
  #R=R*2
  for(w=-pi/2;w<pi/2;w+=dw){
    R=heartR(w,0.1)
    x=(R*cos(w)+maxx)/maxx/2
    y=1-(R*sin(w)+4)/4.65
    heart[int(y*kY+oY+0.5) " " int(kX*   x +oX+0.5)]
    heart[int(y*kY+oY+0.5) " " int(kX*(1-x)+oX+0.5)]
  }
}
{system("tput cup 0 0")
  if(NR>=35){NR=0}
  cur_char=H[int(NR/5)]
  for(i in heart){
    if(rand()<0.5){
      split(i, yx)
      curY=yx[1];curX=yx[2]
      scr=gensub(".",cur_char,(yx[1]*col+yx[2]+1),scr)
    }
  }
print scr
}
'
