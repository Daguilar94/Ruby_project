module QA
  def create_qa
    base = File.open('preguntas.txt','r')
    banco=[]
    preguntas=[]
    respuestas=[]
    cont = 1
    base.each_line.with_index do |line, index|
      if !line.chomp.empty?
        if cont == 1
          preguntas << line.chomp
          cont += 1
        elsif cont == 2
          respuestas << line.chomp
          cont = 1
        end
      end
    end
    base.rewind
    base.close

    respuestas.length.times do |t|
      banco << {Q: "#{preguntas[t]}", A: "#{respuestas[t]}"}
    end
    banco
  end
  def self.initial_prompt
    puts 'Bienvenido a reto 5'
    puts ""
    puts 'Para jugar, solo ingresa el termino correcto para cada una de las definiciones'
    puts ""
    puts 'Listo? Vamos!'
    puts ""
  end
  def self.second_prompt question
    puts 'Definición: '
    puts ""
    puts "#{question}"
    puts ""
  end
  def self.validate(correct, nwrong, answer, contador)
    while correct == false && nwrong < 3 do
      puts 'Adivinar: '
      puts ""
      a = gets.chomp.downcase
      puts ""
      if a == answer
        puts 'Correcto!'
        puts ""
        correct = true
        contador += 1
      else
        nwrong += 1
        puts 'Incorrecto!, Trata de nuevo'
        puts ""
      end
    end
    nwrong
  end
  def self.final(contador, nques)
    if contador == nques
      puts 'Felicitaciones, has contestado correctamente todas las preguntas'
    else
      puts 'Lo siento, te has equivocado 3 veces en responder la misma pregunta. Vuelve a comenzar'
    end
  end
end
class DB
  include QA
  attr_reader :qna
  def initialize
  @qna = create_qa
  end
end

class Quiz
  attr_reader :num, :qna, :q, :a
  def initialize num, qna
    @num = num
    @qna = qna
  end
  def generate_quiz
    @q = @qna[@num][:Q]
    @a = @qna[@num][:A]
  end
end

#------------JUEGO--------------

db = DB.new
nques = db.qna.length

nwrong = 0
contador = 0

QA.initial_prompt

while nwrong < 3 && contador < nques do
  q = Quiz.new(contador,db.qna)
  q.generate_quiz
  QA.second_prompt q.q
  correct = false
  nwrong = 0
  nwrong = QA.validate(correct, nwrong, q.a, contador)
  contador += 1 if nwrong < 3
end

QA.final(contador, nques)
