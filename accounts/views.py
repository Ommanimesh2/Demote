from django.contrib.auth import authenticate
from django.shortcuts import render
from rest_framework import generics, status
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import SignUpSerializer,UserSerializer
from .tokens import create_jwt_pair_for_user
from .models import User

# Create your views here.


class SignUpView(generics.GenericAPIView):
    serializer_class = SignUpSerializer
    permission_classes = []

    def post(self, request: Request):
        data = request.data

        serializer = self.serializer_class(data=data)

        if serializer.is_valid():
            serializer.save()

            response = {"message": "User Created Successfully", "data": serializer.data}

            return Response(data=response, status=status.HTTP_201_CREATED)

        return Response(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginView(APIView):
    permission_classes = []

    def post(self, request: Request):
        email = request.data.get("email")
        password = request.data.get("password")
        try:
            userdet = User.objects.get(email=email)
            serializer= UserSerializer(userdet)
        
            user = authenticate(email=email, password=password)
    
            if user is not None:

                tokens = create_jwt_pair_for_user(user)

                response = {"user": serializer.data, "tokens": tokens}
                return Response(data=response, status=status.HTTP_200_OK)

            else:
                return Response(data={"message": "Invalid email or password"})
        except:
            return Response(data={"message": "Invalid"})
    

class LogoutView(APIView):
    permission_classes =[]

    def post(self, request):
        try:
            refresh_token = request.data["refresh_token"]
            token = RefreshToken(refresh_token)
            token.blacklist()

            return Response(status=status.HTTP_205_RESET_CONTENT)
        except Exception as e:
            return Response(status=status.HTTP_400_BAD_REQUEST)


class UserDetails(APIView):
    def get_object(self,request ,pk):
        try:
            return User.objects.get(pk=pk)
        
        except User.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        
    def get(self, request: Request,pk):
         
         user= self.get_object(self , pk)
         serializer= UserSerializer(user)
         print(serializer.data)
         return Response(data=serializer.data, status=status.HTTP_200_OK)
    

    def put(self, request, pk):
        List = self.get_object(self, pk)
        serializer = UserSerializer(List, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)