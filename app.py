from flask import Flask, render_template, request, jsonify
import mysql.connector

app = Flask(__name__)

# Configuração da conexão com o seu Banco de Dados MySQL
def conectar_banco():
    return mysql.connector.connect(
        host="localhost",
        user="root",        # Altere para o seu usuário do MySQL (ex: root)
        password="",    # Altere para a sua senha do MySQL
        database="cupcake_store"
    )

@app.route('/')
def index():
    return "Servidor da Cupcake Store rodando com sucesso!"

# Rota que recebe os dados do pedido enviados pelo site
@app.route('/salvar-pedido', methods=['POST'])
def salvar_pedido():
    dados = request.get_json()
    
    cliente = dados.get('cliente')
    total = dados.get('total')
    protocolo = dados.get('protocolo')

    conexao = conectar_banco()
    cursor = conexao.cursor()

    try:
        # 1. Salva os dados do cliente
        sql_cliente = "INSERT INTO clientes (nome, telefone, endereco, forma_pagamento) VALUES (%s, %s, %s, %s)"
        valores_cliente = (cliente['nome'], cliente['telefone'], cliente['endereco'], cliente['pagamento'])
        cursor.execute(sql_cliente, valores_cliente)
        conexao.commit()
        
        cliente_id = cursor.lastrowid # Pega o ID do cliente recém cadastrado

        # 2. Salva o pedido vinculado ao cliente
        sql_pedido = "INSERT INTO pedidos (cliente_id, total, protocolo) VALUES (%s, %s, %s)"
        valores_pedido = (cliente_id, total, protocolo)
        cursor.execute(sql_pedido, valores_pedido)
        conexao.commit()

        return jsonify({"sucesso": True, "mensagem": "Pedido salvo no MySQL com sucesso!"})

    except Exception as e:
        conexao.rollback()
        return jsonify({"sucesso": False, "erro": str(e)})

    finally:
        cursor.close()
        conexao.close()

if __name__ == '__main__':
    app.run(debug=True)
