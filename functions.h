#include <string.h>
#include <stdio.h>
int nr = 0, functions = 0;
char variabile[100][100];
char functii[100][100];
char signatures[100][100];
char tip[100][100];
int initializat[100];
int valoare[100];
int valoareArr[100][100];
char valoarec[100];
char valoares[100][100];
char valoareb[100][100];
float valoaref[100];
int scope[100];
int fctScope[100];
int sizes[100];
FILE * f;
void declare(char type[], char var[], int scop){
    strcpy(variabile[nr], var);
    strcpy(tip[nr], type);
    scope[nr] = scop;
    nr++;
}
void declareArr(char var[], int size, int scop){
    strcpy(variabile[nr], var);
    strcpy(tip[nr], "array");
    sizes[nr] = size;
    scope[nr] = scop;
    nr++;
}
int funcDef(char name[], char signature[], int scop){
    for(int i=0;i<functions;i++){
        if(strcmp(signature, signatures[i])==0)
            return 0;
    }
    strcpy(functii[functions], name);
    strcpy(signatures[functions], signature);
    fctScope[functions] = scop;
    functions++;
    return 1;
}
int checkSignature(char name[], char fctprm[], int scop){
    for(int i=0;i<functions;i++){
        if(strcmp(name, functii[i])==0 && scop == fctScope[i]){
            if(strcmp(signatures[i], fctprm)==0)
                return 1;
        }
    }
    return 0;
}
int checkFunc(char name[], int scop){
    for(int i=0;i<functions;i++){
        if(strcmp(name, functii[i])==0 && scop == fctScope[i])
            return 1;
    }
    return 0;
}
int intreg(char var[]){
    if(strcmp(var, "int")==0)
        return 1;
    return 0;
}
int caracter(char var[]){
    if(strcmp(var, "char")==0)
        return 1;
    return 0;
}

int boolean(char var[]){
    if(strcmp(var, "bool")==0)
        return 1;
    return 0;
}
int floatType(char var[]){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0)
            if(strcmp(tip[i],"float")==0)
                return 1;
    }
    return 0;
}
int flot(char var[]){
    if(strcmp(var, "float")==0)
        return 1;
    return 0;
}
int str(char var[]){
    if(strcmp(var,"string")==0)
        return 1;
    return 0;
}
void initialize(char type[], char var[], int val, int scop){
    strcpy(variabile[nr], var);
    strcpy(tip[nr], type);
    initializat[nr] = 1;
    valoare[nr] = val;
    scope[nr] = scop;
    nr++;
}
void initializef(char type[], char var[], float val, int scop){
    strcpy(variabile[nr], var);
    strcpy(tip[nr], type);
    initializat[nr] = 1;
    valoaref[nr] = val;
    scope[nr] = scop;
    nr++;
}
void initializec(char type[], char var[], char c[], int scop){
    strcpy(variabile[nr], var);
    strcpy(tip[nr], type);
    initializat[nr] = 1;
    valoarec[nr] = c[1];
    scope[nr] = scop;
    nr++;
    
}
void initializes(char type[], char var[], char c[], int scop){
    strcpy(variabile[nr], var);
    strcpy(tip[nr], type);
    initializat[nr] = 1;
    strcpy(valoares[nr], c);
    scope[nr] = scop;
    nr++;
}
void initializeb(char type[], char var[], char c[], int scop){
    strcpy(variabile[nr], var);
    strcpy(tip[nr], type);
    initializat[nr] = 1;
    strcpy(valoareb[nr], c);
    scope[nr] = scop;
    nr++;
}
int initialized(char var[], int scop){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0 && scop == scope[i])
            if(initializat[i]==1)
                return 1;
    }
    return 0;
}
void multiply(char var[], int nr)
{
    char str[100];
    char aux[100];
    strcpy(aux, var+1);
    aux[strlen(aux)-1]='\0';
        while(nr){
            strcat(str, aux);
            nr--;
        }
    printf("%s\n",str);
}

void strrev(char *str){
    char *p1, *p2;
    str[strlen(str)-1] = '\0';
    for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2){
        *p1 ^= *p2;
        *p2 ^= *p1;
        *p1 ^= *p2;
    }
    str[strlen(str)-1] = '\0';
    printf("%s\n",str);
}

void concat(char *s1, char* s2){
    char str1[100], str2[100];
    strcpy(str1, s1);
    strcpy(str2,s2);
    str1[strlen(str1)-1] = '\0';
    char aux[100];
    strcpy(aux, str1+1);
    strcpy(str1, aux);
    strcpy(aux, str2+1);
    strcpy(str2, aux);
    str2[strlen(str2)-1] = '\0';
    strcat(str1, str2);
    printf("%s\n", str1);
}
int check(char var[], int scop){
    for(int i=0;i<nr;i++){
        if(!strcmp(var, variabile[i]) && scop == scope[i])
        return 0;
    }
    return 1;
}
char * getType(char var[]){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0)
           return tip[i];
    }
}
int value(char var[], int scop){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0 && scop==scope[i])
            return valoare[i];
    }
}
float valuef(char var[], int scop){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0 && scop==scope[i])
            return valoaref[i];
    }
}
char valuec(char var[], int scop){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0 && scop==scope[i])
            return valoarec[i];
    }
}
char * values(char var[], int scop){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0 && scop==scope[i])
            return valoares[i];
    }
}
int intType(char var[]){
    for(int i=0;i<nr;i++){
        if(strcmp(var, variabile[i])==0)
            if(strcmp(tip[i],"int")==0)
                return 1;
    }
    return 0;
}

int atribuire(char var[], int val, int scop){
    if(check(var, scop)==0){
        for(int i=0;i<nr;i++){
            if(strcmp(var, variabile[i])==0 && scope[i] == scop){
                valoare[i] = val;
                return 1;
            }
        }
    }
    return 0;
}
int atribuiref(char var[], float val, int scop){
    if(check(var, scop)==0){
        for(int i=0;i<nr;i++){
            if(strcmp(var, variabile[i])==0 && scope[i] == scop){
                valoaref[i] = val;
                return 1;
            }
        }
    }
    return 0;
}
int atribuirec(char var[], char c, int scop){
    if(check(var, scop)==0){
        for(int i=0;i<nr;i++){
            if(strcmp(var, variabile[i])==0 && scope[i] == scop){
                valoarec[i] = c;
                return 1;
            }
        }
    }
    return 0;
}
int atribuires(char var[], char s[], int scop){
    if(check(var, scop)==0){
        for(int i=0;i<nr;i++){
            if(strcmp(var, variabile[i])==0 && scope[i] == scop){
                strcpy(valoares[i], s);
                return 1;
            }
        }
    }
    return 0;
}
int atribuireArr(char var[], int val, int index, int scop){
    if(check(var, scop)==0){
        for(int i=0;i<nr;i++){
            if(strcmp(var, variabile[i])==0 && scope[i] == scop){
                valoareArr[i][index] = val;
                return 1;
            }
        }
    }
    return 0;
}
void print(){
    f = fopen("symbol_table", "w");
    fputs("Variabile:\n", f);
    for(int i=0;i<nr;i++){
        char c[10];
        if(scope[i]==1)
            fputs("scope:global",f);
        else if(scope[i]==2)
            fputs("scope:clasa", f);
        else if(scope[i]==3)
            fputs("scope:functie",f);
        fputs(" tip:",f);
        fputs(tip[i], f);
        fputs(" nume:", f);
        fputs(variabile[i], f);
        if(strcmp(tip[i], "int")==0)
            sprintf(c, "%d", valoare[i]);
        else if(strcmp(tip[i],"float")==0)
            sprintf(c, "%f", valoaref[i]);
        else if(strcmp(tip[i], "char")==0){
            char aux = valoarec[i];
            bzero(c, 10);
            c[0] = aux;
        }
        else if(strcmp(tip[i], "string")==0){
            strcpy(c, valoares[i]);
        }
        else if(strcmp(tip[i], "bool")==0){
            strcpy(c, valoareb[i]);
        }
        else if(strcmp(tip[i],"array")==0){
            fputs(" size:",f);
            sprintf(c, "%d", sizes[i]);
            fputs(c,f);
            fputs(" valoare:",f);
            for(int j=0;j<sizes[i];j++){
                sprintf(c, "%d", valoareArr[i][j]);
                fputs(c,f);
                fputs(" ",f);
            }
            fputs("\n",f);
        }
        if(strcmp(tip[i],"array")!=0){
            fputs(" valoare:", f);
            fputs(c, f);
            fputs("\n", f);
        }
        
    }
    fputs("\nFunctii:\n", f);
    for(int i=0;i<functions;i++){
        fputs("nume:", f);
        fputs(functii[i],f);
        fputs(" signatura:", f);
        fputs(signatures[i], f);
        fputs("scope:",f);
        if(fctScope[i]==1)
            fputs("global",f);
        else if(fctScope[i]==2)
            fputs("clasa", f);
        fputs("\n",f);
    }
}