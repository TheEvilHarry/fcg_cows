#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da cor de cada vértice, definidas em "shader_vertex.glsl" e
// "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define SPHERE 0
#define BUNNY  1
#define PLANE  2
#define COW    3
#define FLOOR  4
#define ONEWALL 5
#define TWOWALL 6
#define THREEWALL 7

#define CUBE 8
#define DOOR 9
#define KEYF 10
#define PLANEOVER 11
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec3 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(vec4(1.0,1.0,0.0,0.0));

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

        // Vetor que define o sentido da reflexão especular ideal.
    vec4 r = -l + 2 * n * dot(n,l); // PREENCHA AQUI o vetor de reflexão especular ideal


    //Vetor h, o half-vector entre v e l. (Usado para a reflexão Blinn-Phong).
    vec4 h = normalize(v + l);

    vec3 Kd; // Refletância difusa
    vec3 Ks; // Refletância especular
    vec3 Ka; // Refletância ambiente
    float q; // Expoente especular para o modelo de iluminação de Phong

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

    if ( object_id == SPHERE )
    {
        // PREENCHA AQUI as coordenadas de textura da esfera, computadas com
        // projeção esférica EM COORDENADAS DO MODELO. Utilize como referência
        // o slide 139 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // A esfera que define a projeção deve estar centrada na posição
        // "bbox_center" definida abaixo.

        // Você deve utilizar:
        //   função 'length( )' : comprimento Euclidiano de um vetor
        //   função 'atan( , )' : arcotangente. Veja https://en.wikipedia.org/wiki/Atan2.
        //   função 'asin( )'   : seno inverso.
        //   constante M_PI
        //   variável position_model


        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
        float rho = 1;

        vec4 p_linha = bbox_center + rho*(position_model - bbox_center)/length(position_model - bbox_center);

        vec4 p_vetor = position_model - bbox_center;

        rho = length(p_vetor);

        float phi = asin(p_vetor.y/rho);
        float theta = atan(p_vetor.x, p_vetor.z);


        U = (theta + M_PI)/(2*M_PI);
        V = (phi + (M_PI/2))/M_PI;

    }
    else if ( object_id == BUNNY )
    {
        // PREENCHA AQUI as coordenadas de textura do coelho, computadas com
        // projeção planar XY em COORDENADAS DO MODELO. Utilize como referência
        // o slide 106 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf",
        // e também use as variáveis min*/max* definidas abaixo para normalizar
        // as coordenadas de textura U e V dentro do intervalo [0,1]. Para
        // tanto, veja por exemplo o mapeamento da variável 'p_v' utilizando
        // 'h' no slide 151 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".

        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x - minx)/(maxx - minx);


        V = (position_model.y - miny)/(maxy - miny);
    }
    else if (object_id == COW)
    {
        /*
        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x - minx)/(maxx - minx);


        V = (position_model.y - miny)/(maxy - miny);*/
    }
    else if ( object_id == PLANE )
    {
        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
    }
    else if (object_id == FLOOR)
    {
        U = texcoords.x;
        V = texcoords.y;
    }
    else if (object_id == ONEWALL || object_id == TWOWALL || object_id == THREEWALL )
    {
        U = texcoords.x;
        V = texcoords.y;
    }
    else if (object_id == DOOR)
    {
        U = texcoords.x;
        V = texcoords.y;
    }
    else if (object_id == KEYF)
    {
        U = texcoords.x;
        V = texcoords.y;
    }
    else if(object_id == PLANEOVER)
    {
         U = texcoords.x;
         V = texcoords.y;
    }


    // Obtemos a refletância difusa a partir da leitura da imagem TextureImage0
    vec3 Kd0 = texture(TextureImage0, vec2(U,V)).rgb;

     if(object_id==COW)
     {
        Kd = vec3(0.85,0.6,0.1);
        Ks = vec3(0.8,0.8,0.8);
        Ka = vec3(0.425,0.3,0.05);
        q = 80.0;
     }
     else if (object_id==CUBE)
     {
        Kd = vec3(0.8,0.4,0.08);
        Ks = vec3(0.0,0.0,0.0);
        Ka = vec3(0.4,0.2,0.04);
        q = 1.0;
     }
     else if (object_id==DOOR)
     {
         Kd0 = texture(TextureImage2, vec2(U,V)).rgb;
     }
     else if (object_id == KEYF)
     {
         Kd0 = texture(TextureImage1, vec2(U,V)).rgb;
     }



    // Equação de Iluminação
    float lambert = max(0,dot(n,l));



        // Equação de Iluminação
    if(object_id==CUBE){
        vec3 I = vec3(1.0,1.0,1.0);
        vec3 Ia = vec3(0.4,0.4,0.4);
        vec3 lambert_diffuse_term = Kd * I * max(0, dot(n,l));
        vec3 ambient_term = Ka * Ia;
        vec3 phong_specular_term = Ks * I * max(0,pow(dot(r,v), q));
        color = lambert_diffuse_term + ambient_term + phong_specular_term;
    }
    else if(object_id==COW)
    {
        vec3 I = vec3(1.0,1.0,1.0);
        vec3 Ia = vec3(0.4,0.4,0.4);
        vec3 lambert_diffuse_term = Kd * I * max(0, dot(n,l));
        vec3 ambient_term = Ka * Ia;
        vec3 phong_specular_term = Ks * I * max(0,pow(dot(n,h), q));
        color = lambert_diffuse_term + ambient_term + phong_specular_term;
    }
    else{
        color = Kd0 * (lambert + 0.01);
    }

    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color = pow(color, vec3(1.0,1.0,1.0)/2.2);
}
