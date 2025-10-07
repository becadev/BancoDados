from django.db import models
from .choices import *


class Autores(models.Model):
    nome = models.CharField(max_length=100)
    dta_nascimento = models.DateField()
    nacionalidade = models.CharField(max_length=1, choices = NACIONALIDADE_CHOICES, default='brasileiro')

    def __str__(self):
        return self.nome

class Livros(models.Model):
    titulo = models.Charfield(max_length = 200, blank = False)
    autor = models.ForeignKey(Autores, on_delete=models.CASCADE, max_length = 100, blank = False)
    ano_publi = models.DateField(blank = False, null=False)
    genero = models.Charfield(max_length = 1, choices = GENEROS_CHOICES, default = '')
    
    def __str__(self):
        return self.titulo
    

class Usuario(models.Model):
    nome = models.CharField(max_length=100)
    email = models.EmailField(unique=True, blank=False)
    dta_register = models.DateField(auto_now_add=True)

    def __str__(self):
        return self.email
    
class Reservas(models.Model):
    id_livro = models.ForeignKey(Livros, on_delete=models.CASCADE, verbose_name='livros')
    id_usuario = models.ForeignKey(Usuario, verbose_name='Usuario')
    dta_reservas = models.DateField(auto_now_add = True)

    def __str__(self):
        return f'Livro: {self.id_livro.titulo} - Dta_reserva: {self.dta_reservas}'
    

class Multas(models.Model):
    id_usuario = models.ForeignKey(Usuario, on_delete=True, related_name='Usuario')
    valor = models.DecimalField(blank=False, null=False)
    dta_pagamento = models.DateField(default=None)

    def __str__(self):
        return f'{self.id_usuario.nome} - Valor multa: {self.valor}'
    
class Categorias(models.Model):
    nome = models.CharField(max_length=100 ,blank=False, null=False)
    descricao = models.CharField(max_length=100 ,blank=False, null=False)
    
    def __str__(self):
        return self.nome
    
class Editoras(models.Model):
    nome_editora = models.CharField(max_length=100 ,blank=False, null=False)
    
    
