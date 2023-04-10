/*
*>******************************************************************************
*>  particelle.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  particelle.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with particelle.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************
*/

// ************************************************************
// Questo file (ex main) è stato diviso in 4 funzioni per essere integrato in CobolDraw.cob.
// Il file originale fa parte delle librerie di esempio di Raylib e lo trovate a questo link:
// https://www.raylib.com/examples/textures/loader.html?name=textures_particles_blending
//
// Tectonics: cobc -c particelle.c -lraylib
//            cobc -x -free CobolDraw.cob particelle.o -lraylib
//            ./CobolDraw
//*************************************************************

#include "raylib.h"

#define MAX_PARTICLES 200

typedef struct {
    Vector2 position;
    Color color;
    float alpha;
    float size;
    float rotation;
    bool active;
} Particle;

Particle mouseTail[MAX_PARTICLES] = { 0 };

float gravity = 0.0f;

int blending = BLEND_ALPHA;

Texture2D smoke;


int particelle1(int risposta)
{
    if (risposta == 5) smoke = LoadTexture("spark_flame_big.png");
       else smoke = LoadTexture("spark_flame_small.png"); 
    
    
    for (int i = 0; i < MAX_PARTICLES; i++)
    {
        mouseTail[i].position = (Vector2){ 0, 0 };
        mouseTail[i].color = (Color){ GetRandomValue(0, 255), GetRandomValue(0, 255), GetRandomValue(0, 255), 255 };
        mouseTail[i].alpha = 1.0f;
        mouseTail[i].size = (float)GetRandomValue(1, 30)/20.0f;
        mouseTail[i].rotation = (float)GetRandomValue(0, 360);
        mouseTail[i].active = false;
    }

    return 0;
}


int particelleblend()
{
    if (IsKeyPressed(KEY_SPACE))
        {
            if (blending == BLEND_ALPHA) blending = BLEND_ADDITIVE;
            else blending = BLEND_ALPHA;
        }
        
    if (IsKeyPressed(KEY_F1))
        gravity = 0.2;
    
    if (IsKeyPressed(KEY_F2))
        gravity = 0.8;
    
    if (IsKeyPressed(KEY_F3))
        gravity = 2.0;
    
    if (IsKeyPressed(KEY_F4))
        gravity = 3.0;
    
    if (IsKeyPressed(KEY_F10))
        gravity = 0.0;
        
    return blending;
}

int particelle2(int blending)
{
        for (int i = 0; i < MAX_PARTICLES; i++)
        {
            if (!mouseTail[i].active)
            {
                mouseTail[i].active = true;
                mouseTail[i].alpha = 1.0f;
                mouseTail[i].position = GetMousePosition();
                i = MAX_PARTICLES;
            }
        }

        for (int i = 0; i < MAX_PARTICLES; i++)
        {
            if (mouseTail[i].active)
            {
                mouseTail[i].position.y += gravity/2;
                mouseTail[i].alpha -= 0.005f;

                if (mouseTail[i].alpha <= 0.0f) mouseTail[i].active = false;

                mouseTail[i].rotation += 2.0f;
            }
        }

        BeginBlendMode(blending);

            for (int i = 0; i < MAX_PARTICLES; i++)
            {
                if (mouseTail[i].active) DrawTexturePro(smoke, (Rectangle){ 0.0f, 0.0f, (float)smoke.width, (float)smoke.height },
                                                       (Rectangle){ mouseTail[i].position.x, mouseTail[i].position.y, smoke.width*mouseTail[i].size, smoke.height*mouseTail[i].size },
                                                       (Vector2){ (float)(smoke.width*mouseTail[i].size/2.0f), (float)(smoke.height*mouseTail[i].size/2.0f) }, mouseTail[i].rotation,
                                                       Fade(mouseTail[i].color, mouseTail[i].alpha));
            }

        EndBlendMode();

        DrawRectangle(30, 380, 550, 40, BLACK);
        DrawText("Press the space bar to cancel or to change the BLENDING mode:  color   or   bright", 35, 382, 13, WHITE);

        if (blending == BLEND_ALPHA) DrawText("Alpha BLENDING", 400, 8, 20, WHITE);
        else DrawText("Additive BLENDING", 380, 8, 20, WHITE);
        
        return 0;
}

int particelle3(void)
{
        UnloadTexture(smoke);
        
        return 0;
}
