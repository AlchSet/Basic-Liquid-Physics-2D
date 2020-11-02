using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BasicLiquidPhysics2D
{
    public class Water : MonoBehaviour
    {
        public Rigidbody2D rigidbody;
        public CircleCollider2D collider;



        private void Awake()
        {
            Initialize();
        }


        public void Initialize()
        {
            rigidbody = GetComponent<Rigidbody2D>();
            collider=GetComponent<CircleCollider2D>();
        }

        public void SetActive(bool b)
        {
            gameObject.SetActive(b);
        }

        public void SetPosition(Vector3 pos)
        {
            transform.position = pos;
        }

        public void SetRadius(float r)
        {
            collider.radius = r;
        }

    }
}