CREATE TABLE IF NOT EXISTS CepEndereco (
    CEP VARCHAR(8) NOT NULL PRIMARY KEY,
    rua VARCHAR(100),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    pais VARCHAR(50)
);

/* IES */
CREATE TABLE IF NOT EXISTS IES (
    CNPJ VARCHAR(14) NOT NULL PRIMARY KEY,
    sigla VARCHAR(10),
    participou_isf BOOLEAN,
    tem_lab_mais_unidos BOOLEAN,
    possui_nucleo_ativo BOOLEAN,
    CEP_IES VARCHAR(8),
  	numero INTEGER,
  	complemento VARCHAR(100),
    link_politica_ling VARCHAR(255),
    data_politica_ling DATE,
    doc_politica_ling VARCHAR(255),
    campus VARCHAR(100),
    nome_principal VARCHAR(100),

  	FOREIGN KEY (CEP_IES) REFERENCES CepEndereco(CEP)
);

CREATE TABLE IF NOT EXISTS TelefoneIES (
    CNPJ_IES VARCHAR(14) NOT NULL,
    DDD VARCHAR(3) NOT NULL,
    DDI VARCHAR(3) NOT NULL,
    numero VARCHAR(15) NOT NULL,

    PRIMARY KEY (CNPJ_IES, DDI, DDD, numero),
    FOREIGN KEY (CNPJ_IES) REFERENCES IES(CNPJ)
);

/* USUÁRIO */
CREATE TABLE IF NOT EXISTS Usuario (
	CPF VARCHAR(11) NOT NULL PRIMARY KEY,
  	primeiro_nome VARCHAR(50) NOT NULL,
  	sobrenome VARCHAR(50) NOT NULL,
  	genero VARCHAR(20),
  	data_nascimento DATE NOT NULL,
  	numero INTEGER,
  	complemento VARCHAR(100),
  	CEP_usuario VARCHAR(8),
  	CNPJ_IES_associada VARCHAR(20),

  	FOREIGN KEY (CEP_usuario) REFERENCES CepEndereco(CEP),
  	FOREIGN KEY (CNPJ_IES_associada) REFERENCES IES(CNPJ)
);

CREATE TABLE IF NOT EXISTS TelefoneUsuario (
    CPF_usuario VARCHAR(14) NOT NULL,
    DDD VARCHAR(3) NOT NULL,
    DDI VARCHAR(3) NOT NULL,
    numero VARCHAR(15) NOT NULL,

    PRIMARY KEY (CPF_usuario, DDI, DDD, numero),
  	FOREIGN KEY (CPF_usuario) REFERENCES Usuario(CPF)
);

/* COORDENADOR ADMINISTRATIVO */
CREATE TABLE IF NOT EXISTS CoordenadorAdministrativo (
    CPF_coordenador VARCHAR(11) NOT NULL PRIMARY KEY,
    funcao_na_instituicao VARCHAR(100),
    curriculo_lates VARCHAR(255),
    data_cadastro DATE,
    POCA VARCHAR(50),

    FOREIGN KEY (CPF_coordenador) REFERENCES Usuario(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS CoordenadorAdministrativoCadastraIES (
    CNPJ_IES VARCHAR(14) NOT NULL,
    CPF_coordenador_administrativo VARCHAR(11) NOT NULL,
    termo_de_compromisso VARCHAR(255),

    PRIMARY KEY (CNPJ_IES, CPF_coordenador_administrativo),
    FOREIGN KEY (CNPJ_IES) REFERENCES IES(CNPJ),
    FOREIGN KEY (CPF_coordenador_administrativo) REFERENCES CoordenadorAdministrativo(CPF_coordenador)
);

/* PARCEIRO */ 
CREATE TABLE IF NOT EXISTS Parceiro(
    CNPJ VARCHAR(14) NOT NULL PRIMARY KEY,
    primeiro_nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    categoria_atuacao VARCHAR(500),
    CEP_parceiro VARCHAR(8),
    numero DECIMAL(5),
    complemento VARCHAR(100),

    FOREIGN KEY (CEP_parceiro) REFERENCES CepEndereco(CEP)
);

CREATE TABLE IF NOT EXISTS TelefoneParceiro(
    CNPJ_parceiro VARCHAR(14) NOT NULL,
    DDI DECIMAL(3),
    DDD DECIMAL(2),
    numero DECIMAL(9) NOT NULL,

    PRIMARY KEY (CNPJ_Parceiro, DDI, DDD, numero),
  	FOREIGN KEY (CNPJ_parceiro) REFERENCES Parceiro(CNPJ)
);

/* GESTOR */
CREATE TABLE IF NOT EXISTS GestorRedeAndifes (
    CPF_gestor VARCHAR(11) NOT NULL PRIMARY KEY,
    data_cadastro DATE,

  	FOREIGN KEY (CPF_gestor) REFERENCES Usuario(CPF)
);

CREATE TABLE IF NOT EXISTS GestorAnalisaParceiro(
    CPF_gestor VARCHAR(11) NOT NULL,
    CNPJ_parceiro VARCHAR(14) NOT NULL,
    status_ VARCHAR(20),  
    data_analise DATE,

    CHECK(status_ in ('APROVADO', 'REPROVADO')),

    PRIMARY KEY (CPF_gestor, CNPJ_parceiro),
    FOREIGN KEY (CPF_gestor) REFERENCES GestorRedeAndifes(CPF_gestor),
    FOREIGN KEY (CNPJ_parceiro) REFERENCES Parceiro(CNPJ)
);

CREATE TABLE IF NOT EXISTS GestorAprovaCoordAdm (
    CPF_gestor_rede_andifes VARCHAR(11) NOT NULL,
    CPF_coordenador_administrativo VARCHAR(11) NOT NULL,
    data_fim TIMESTAMP,
    data_inicio TIMESTAMP,
    documento_de_atuacao VARCHAR(255),

    CHECK (data_inicio < data_fim),

    PRIMARY KEY (CPF_gestor_rede_andifes, CPF_coordenador_administrativo),
    FOREIGN KEY (CPF_gestor_rede_andifes) REFERENCES GestorRedeAndifes(CPF_gestor),
    FOREIGN KEY (CPF_coordenador_administrativo) REFERENCES CoordenadorAdministrativo(CPF_coordenador)
);

/* EDITAL */
CREATE TABLE IF NOT EXISTS Edital(
    ID_edital INTEGER,      
    numero DECIMAL(30) NOT NULL,
    ano DECIMAL(4) NOT NULL,
    semestre DECIMAL(1) NOT NULL,
    data_publicacao DATE,
    data_inicio DATE,
    data_fim DATE,
    edital_file VARCHAR(255), 
    nome VARCHAR(100) NOT NULL,

    CHECK(data_inicio < data_fim), 
    PRIMARY KEY (ID_edital),
    UNIQUE (numero, ano, semestre)
);

CREATE TABLE IF NOT EXISTS EditalOfertaColetiva(
    ID_edital INTEGER,      
    max_alunos_turma  DECIMAL(4),
    max_alunos_lista_espera  DECIMAL(4),
    max_vagas_reservadas_turma DECIMAL(3),
    
    PRIMARY KEY(ID_edital),
    FOREIGN KEY (ID_edital) REFERENCES Edital(ID_edital)

);

CREATE TABLE IF NOT EXISTS IdiomasEditalOfertaColetiva(
    ID_edital INTEGER,      
    idioma VARCHAR(50) NOT NULL,

    PRIMARY KEY (ID_edital, idioma),
    FOREIGN KEY (ID_edital) REFERENCES EditalOfertaColetiva(ID_edital)
);

CREATE TABLE IF NOT EXISTS EditalCredEspecialista(
    ID_edital INTEGER,     

    PRIMARY KEY (ID_edital),
    FOREIGN KEY (ID_edital) REFERENCES Edital(ID_edital)
);

CREATE TABLE IF NOT EXISTS EditalCredProfessorIsf(
    ID_edital INTEGER,      

    PRIMARY KEY (ID_edital),
    FOREIGN KEY (ID_edital) REFERENCES Edital(ID_edital)
);

CREATE TABLE IF NOT EXISTS EditalAlunoEspecializacao(
    ID_edital INTEGER,      
    quantidade_vagas DECIMAL(4),

    PRIMARY KEY (ID_edital),
    FOREIGN KEY (ID_edital) REFERENCES Edital(ID_edital)
);

/* PROFESSOR ISF */
CREATE TABLE IF NOT EXISTS ProfessorIsf(
    CPF_professor_isf VARCHAR(11) NOT NULL,
    
    PRIMARY KEY(CPF_professor_isf),
    FOREIGN KEY (CPF_professor_isf) REFERENCES Usuario(CPF)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS IdiomaProfessorIsf(
    CPF_professor_isf VARCHAR(11),
    idioma VARCHAR(30),
    proficiencia VARCHAR(5),
    declaracao_proficiencia VARCHAR(256),

    PRIMARY KEY(CPF_professor_isf, idioma),
    FOREIGN KEY (CPF_professor_isf) REFERENCES ProfessorIsf(CPF_professor_isf)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

/* REPOSITORIO */
CREATE TABLE IF NOT EXISTS Repositorio(
    titulo VARCHAR(20) NOT NULL,
    link VARCHAR(50) NOT NULL,
    data_Inclusao DATE,

    PRIMARY KEY (titulo)
);

/* ALUNO ESPECIALIZACAO */
CREATE TABLE IF NOT EXISTS AlunoEspecializacao(
    CPF_aluno_especializacao VARCHAR(11) NOT NULL, 
    titulacao VARCHAR(40) NOT NULL,
    data_ingresso DATE,
    data_conclusao DATE,
    diploma_file VARCHAR(255),

    CHECK(data_ingresso < data_conclusao),
    PRIMARY KEY (CPF_aluno_especializacao),
    FOREIGN KEY (CPF_aluno_especializacao) REFERENCES ProfessorIsf(CPF_professor_isf)
);

CREATE TABLE IF NOT EXISTS AlunoEspecializacaoProduzRepositorio(
    CPF_aluno_especializacao VARCHAR(11) NOT NULL,
    repositorio_titulo VARCHAR(20) NOT NULL,
    foi_validado_pelo_orientador BOOLEAN,
    
    PRIMARY KEY (CPF_aluno_especializacao, repositorio_titulo),
    FOREIGN KEY (CPF_aluno_especializacao) REFERENCES AlunoEspecializacao(CPF_aluno_especializacao),
    FOREIGN KEY (repositorio_titulo) REFERENCES Repositorio(titulo)
);

/* MATERIAIS */
CREATE TABLE IF NOT EXISTS Material(
    ID_material INTEGER,            
    nome VARCHAR(50),
    data_criacao DATE,
    arquivo VARCHAR(256),
    link VARCHAR(256),
    tipo_material VARCHAR(10),

    PRIMARY KEY (ID_material),
    UNIQUE (nome, data_criacao)
);

/* COMPONENTE CURRICULAR */
CREATE TABLE IF NOT EXISTS ProficienciaIdiomaComponente(
  nome_idioma VARCHAR(50),
  proficiencia VARCHAR(10),

  PRIMARY KEY (nome_idioma)
);

CREATE TABLE IF NOT EXISTS ComponenteCurricular(
  nome_componente VARCHAR(100) NOT NULL,
  nome_idioma VARCHAR(50),
  carga_horaria_pratica TIME,
  carga_horaria_teorica TIME,
  obrigatoriedade BOOLEAN,
  eixo_tematico VARCHAR(50),
  
  PRIMARY KEY (nome_componente),
  FOREIGN KEY (nome_idioma) REFERENCES ProficienciaIdiomaComponente(nome_idioma)
);

CREATE TABLE IF NOT EXISTS TipoComponenteCurricular(
    nome_completo VARCHAR(100),
    tipo_disciplina VARCHAR(50),

    PRIMARY KEY (nome_completo),
    FOREIGN KEY (nome_completo) REFERENCES ComponenteCurricular(nome_componente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS MaterialComponenteCurricular(
    ID_material INTEGER,            
    nome_componente VARCHAR(100) NOT NULL,

    PRIMARY KEY (nome_componente, ID_material),
    FOREIGN KEY (nome_componente) REFERENCES ComponenteCurricular(nome_componente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ID_material) REFERENCES Material(ID_material)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS DependenciasComponenteCurricular(
    nome_componente_requisito VARCHAR(100),
    nome_componente VARCHAR(100),

    PRIMARY KEY (nome_componente_requisito, nome_componente),
    FOREIGN KEY (nome_componente_requisito) REFERENCES ComponenteCurricular(nome_componente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (nome_componente) REFERENCES ComponenteCurricular(nome_componente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

/* TURMA ESPECIALIZACAO */
CREATE TABLE IF NOT EXISTS TurmaEspecializacao(
    ID_turma_especializacao INTEGER,        
    nome_componente VARCHAR(100) NOT NULL,
    sigla VARCHAR(15) NOT NULL,
    semestre DECIMAL(1) NOT NULL,

    hora_inicio TIMESTAMP,
    hora_fim TIMESTAMP,
    qtde_vagas DECIMAL(4),

    CHECK (hora_inicio < hora_fim),

    PRIMARY KEY (ID_turma_especializacao),
    UNIQUE (nome_componente, sigla, semestre),
    FOREIGN KEY (nome_componente) REFERENCES ComponenteCurricular (nome_componente)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS DiasTurmaEspecializacao(
    ID_turma_especializacao INTEGER,        
    dia_da_semana VARCHAR(3) NOT NULL,

    PRIMARY KEY (ID_turma_especializacao, dia_da_semana),
    FOREIGN KEY (ID_turma_especializacao) REFERENCES TurmaEspecializacao (ID_turma_especializacao)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS AlunoEspecializacaoCursaTurma(
    ID_turma_especializacao INTEGER,     
    CPF_aluno VARCHAR(11) NOT NULL,
    situacao_aluno VARCHAR(20),
    frequencia DECIMAL(3),

    CHECK(situacao_aluno IN ('APROVADO', 'REPROVADO', 'CURSANDO', 'CANCELADO')),

    CHECK(Frequencia > 0 AND Frequencia < 100), 

    PRIMARY KEY (CPF_aluno, ID_turma_especializacao),
    FOREIGN KEY (CPF_aluno) REFERENCES AlunoEspecializacao(CPF_aluno_especializacao),
    FOREIGN KEY (ID_turma_especializacao) REFERENCES TurmaEspecializacao(ID_turma_especializacao)

);

CREATE TABLE IF NOT EXISTS AtividadesAlunoEspecializacao(
    ID_turma_especializacao INTEGER,        
    CPF_aluno VARCHAR(11) NOT NULL,
    nome_componente VARCHAR(100) NOT NULL,
    sigla VARCHAR(15) NOT NULL,
    semestre DECIMAL(1) NOT NULL,

    atividade VARCHAR(40) NOT NULL,

    nota DECIMAL(4, 2),

    CHECK(nota >= 0 AND nota <= 10),

    PRIMARY KEY (CPF_aluno, atividade, ID_turma_especializacao),
    FOREIGN KEY (CPF_aluno, ID_turma_especializacao) REFERENCES AlunoEspecializacaoCursaTurma(CPF_aluno, ID_turma_especializacao)
);

CREATE TABLE IF NOT EXISTS CursoIdioma(
    ID_curso_idioma INTEGER,  
    nome_completo VARCHAR(256) NOT NULL,
    idioma VARCHAR(16) NOT NULL,
    nivel VARCHAR(16),
    categoria VARCHAR(16),
    carga_horaria SMALLINT,
    link_ementa VARCHAR(256),

    PRIMARY KEY (ID_curso_idioma),
    UNIQUE (nome_completo, idioma)
);

/* OFERTA COLETIVA */ 
CREATE TABLE IF NOT EXISTS TurmaOfertaColetiva(
    ID_turma_coletiva INTEGER,  
    ID_curso_idioma INTEGER NOT NULL,        

    sigla_turma VARCHAR(10) NOT NULL,
    semestre DECIMAL(1) NOT NULL,

    qtde_vagas_Reservadas DECIMAL(4),
    hora_inicio TIMESTAMP,
    hora_fim TIMESTAMP,
    qtde_vagas DECIMAL(4),

    CHECK (hora_inicio < hora_fim),

    PRIMARY KEY (ID_turma_coletiva),
    UNIQUE (sigla_turma, semestre, ID_curso_idioma),
    FOREIGN KEY (ID_curso_idioma) REFERENCES CursoIdioma(ID_curso_idioma)
);

CREATE TABLE IF NOT EXISTS DiasTurmaOfertaColetiva(
    ID_turma_coletiva INTEGER,   
    dia_da_semana VARCHAR(3) NOT NULL,

    PRIMARY KEY (ID_turma_coletiva),
    FOREIGN KEY (ID_turma_coletiva) REFERENCES TurmaOfertaColetiva(ID_turma_coletiva)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS RepositorioTurma(
    ID_turma_coletiva INTEGER,   
    titulo_repositorio VARCHAR(100) NOT NULL,
    foi_aprovado_pelo_orientador BOOLEAN,

    PRIMARY KEY (titulo_repositorio, ID_turma_coletiva),
    FOREIGN KEY (titulo_repositorio) REFERENCES Repositorio (titulo),
    FOREIGN KEY (ID_turma_coletiva) REFERENCES TurmaOfertaColetiva(ID_turma_coletiva)
);

CREATE TABLE IF NOT EXISTS ProfessorIsfMinistraTurma(
    ID_turma_coletiva INTEGER, 
    CPF_professor_isf VARCHAR(11),
    foi_validado_pelo_orientador BOOLEAN,

    PRIMARY KEY(CPF_professor_isf, ID_turma_coletiva),
    FOREIGN KEY (ID_turma_coletiva) REFERENCES TurmaOfertaColetiva(ID_turma_coletiva)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (CPF_professor_isf) REFERENCES ProfessorIsf(CPF_professor_isf)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

/* ALUNO GRADUAÇÃO */
CREATE TABLE IF NOT EXISTS AlunoGraduacao(
    CPF_aluno_graduacao VARCHAR(11),
    termo_compromisso_file VARCHAR(256),
    vinculo_file VARCHAR(256),
    POCA_file VARCHAR(256),

    PRIMARY KEY(CPF_aluno_graduacao),
    FOREIGN KEY (CPF_aluno_graduacao) REFERENCES ProfessorIsf(CPF_professor_isf)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS EditalAdmiteAlunoGraduacao(
    ID_edital INTEGER,     
    CPF_aluno VARCHAR (11),

    PRIMARY KEY (ID_edital, CPF_aluno),
    FOREIGN KEY (ID_edital) REFERENCES Edital(ID_edital),
    FOREIGN KEY (CPF_aluno) REFERENCES AlunoGraduacao(CPF_aluno_graduacao)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

/* ALUNO OFERTA COLETIVA */ 
CREATE TABLE IF NOT EXISTS AlunoOfertaColetiva(
    CPF_aluno VARCHAR(11) NOT NULL,
    vinculo_file VARCHAR(255), 

    PRIMARY KEY (CPF_aluno),
    FOREIGN KEY (CPF_aluno) REFERENCES Usuario(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS IdiomaAlunoOfertaColetiva (
    CPF_aluno VARCHAR(11) NOT NULL,
    idioma VARCHAR(50) NOT NULL,
    proficiencia VARCHAR(50) NOT NULL,
    declaracao_proficiencia VARCHAR(100),
    
    PRIMARY KEY (CPF_aluno, idioma, proficiencia),
    FOREIGN KEY (CPF_aluno) REFERENCES AlunoOfertaColetiva(CPF_aluno)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AlunoInscreveTurmaOferta(
    ID_turma_coletiva INTEGER,  
    CPF_aluno VARCHAR(11) NOT NULL,
    data_inscricao TIMESTAMP NOT NULL,

    posicao_lista DECIMAL(5),
    situacao_inscricao INTEGER,
    data_matricula TIMESTAMP,
    situacao_matricula VARCHAR(20),

    CHECK(situacao_matricula IN ('MATRICULADO', 'EM ESPERA', 'INDEFERIDO')),

    PRIMARY KEY (CPF_aluno, ID_turma_coletiva),
    FOREIGN KEY (CPF_aluno) REFERENCES AlunoOfertaColetiva(CPF_aluno)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (ID_turma_coletiva) REFERENCES TurmaOfertaColetiva (ID_turma_coletiva)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

/* DOCENTE ESPECIALISTA */

CREATE TABLE IF NOT EXISTS DocenteEspecialista(
    CPF_docente VARCHAR(11),
    data_credenciamento DATE,
    curriculo VARCHAR(256),
    titulacao VARCHAR(16),
    poca_file VARCHAR(255),
    vinculo_file VARCHAR(255),
    link_cnpq VARCHAR(255),

    is_orientador BOOLEAN,
    is_autor BOOLEAN,
    is_ministrante BOOLEAN,
    is_coordenador_pedagogico BOOLEAN,

    CHECK((is_orientador IS true) OR 
          (is_autor IS true) OR
          (is_ministrante IS true) OR 
          (is_coordenador_pedagogico IS true)),

    PRIMARY KEY(CPF_docente),
    FOREIGN KEY (CPF_docente) REFERENCES Usuario(CPF)
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS EditalAdmiteDocenteEspecialista(
    ID_edital INTEGER, 
    CPF_docente_especialista VARCHAR(11) NOT NULL,

    PRIMARY KEY (ID_edital, CPF_docente_especialista),
    FOREIGN KEY (ID_edital) REFERENCES Edital(ID_edital),
    FOREIGN KEY (CPF_docente_especialista) REFERENCES DocenteEspecialista(CPF_docente)
);

CREATE TABLE IF NOT EXISTS DocenteAutorProduzMaterial(
    ID_material INTEGER, 
    CPF_docente VARCHAR(11),

    PRIMARY KEY (CPF_docente, ID_material),
    FOREIGN KEY (ID_material) REFERENCES Material(ID_material)
        ON UPDATE CASCADE,
    FOREIGN KEY (CPF_docente) REFERENCES DocenteEspecialista(CPF_docente)
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS HorariosDisponiveisDocenteMinistrante(
    CPF_docente VARCHAR(11) NOT NULL,
    horario_disponivel TIME NOT NULL,

    PRIMARY KEY (CPF_Docente, horario_disponivel),
    FOREIGN KEY (CPF_docente) REFERENCES DocenteEspecialista(CPF_docente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DocenteMinistranteLecionaTurmaEspecializacao(
    ID_turma_especializacao INTEGER,        
    CPF_docente VARCHAR(11) NOT NULL,

    PRIMARY KEY (ID_turma_especializacao, CPF_docente),
    FOREIGN KEY (ID_turma_especializacao) REFERENCES TurmaEspecializacao(ID_turma_especializacao)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (CPF_docente) REFERENCES DocenteEspecialista(CPF_docente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DocenteOrientadorOrientaProfessorIsf(
    CPF_docente VARCHAR(11) NOT NULL,
    CPF_professor_isf VARCHAR(11) NOT NULL,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP,

    PRIMARY KEY (CPF_docente, CPF_professor_isf, data_inicio),
    FOREIGN KEY (CPF_docente) REFERENCES DocenteEspecialista(CPF_docente)
        ON UPDATE CASCADE,
    FOREIGN KEY (CPF_professor_isf) REFERENCES ProfessorIsf(CPF_professor_isf)
        ON UPDATE CASCADE
);