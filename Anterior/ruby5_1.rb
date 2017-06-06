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

puts 'Bienvenido a reto 5'
puts 'Para jugar, solo ingresa el termino correcto para cada una de las definiciones'
puts 'Listo? Vamos!'
nwrong = 0
nques = db.qna.length
contador = 0
while nwrong < 3 && contador < nques do
  q = Quiz.new(contador,db.qna)
  q.generate_quiz
  puts 'Definición: '
  puts "#{q.q}"
  correct = false
  nwrong = 0
  while correct == false && nwrong < 3 do
    puts 'Adivinar: '
    a = gets.chomp.downcase
    if a == q.a
      puts 'Correcto!'
      correct = true
      contador += 1
    else
      nwrong += 1
      puts 'Incorrecto!, Trata de nuevo'
    end
  end
end

if contador == nques
  puts 'Felicitaciones, has contestado correctamente todas las preguntas'
else
  puts 'Lo siento, te has equivocado 3 veces en responder la misma pregunta. Vuelve a comenzar'
end
