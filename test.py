import pytest
from app import app, db, Task
import json

# Configurar un entorno de pruebas
@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'

    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client  # se ejecutan los tests
        with app.app_context():
            db.drop_all()

def test_get_tasks_empty(client):
    """Debe devolver una lista vacía si no hay tareas"""
    response = client.get('/tasks')
    assert response.status_code == 200
    assert response.get_json() == []

def test_create_task_success(client):
    """Debe crear una tarea exitosamente"""
    response = client.post('/tasks', json={"title": "Aprender GitHub Actions"})
    assert response.status_code == 201
    data = response.get_json()
    assert data['title'] == "Aprender GitHub Actions"
    assert data['done'] is False

def test_create_task_without_title(client):
    """Debe fallar si no se proporciona el título"""
    response = client.post('/tasks', json={})
    assert response.status_code == 400
    assert response.get_json()['error'] == 'El campo "title" es obligatorio'
